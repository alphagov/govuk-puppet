require_relative '../../../../spec_helper'

describe 'govuk::app::config', :type => :define do
  context 'title is giraffe' do
    let(:title) { 'giraffe' }

    context 'with no params' do
      it do
        expect {
          is_expected.to contain_file('/var/apps/giraffe')
        }.to raise_error(Puppet::Error, /Must pass app_type/)
      end
    end

    context 'with good params' do
      let(:params) do
        {
          :port => '8000',
          :app_type => 'rack',
          :domain => 'foo.bar.baz',
          :vhost_full => 'giraffe.foo.bar.baz',
        }
      end

      it do
        is_expected.to contain_file('/etc/init/giraffe.conf')
        is_expected.to contain_nginx__config__vhost__proxy('giraffe.foo.bar.baz')
      end

      it do
        is_expected.to contain_collectd__plugin__process('app-giraffe').with(
          :regex => /^unicorn .* -P \/var\/run\/giraffe\/app\\.pid$/
        )
      end

      it do
        is_expected.not_to contain_govuk__app__envvar('giraffe-UNICORN_HERDER_TIMEOUT')
      end

      it do
        is_expected.not_to contain_file('/etc/init/giraffe.conf').with(
          :content => /post-start script/
        )
        is_expected.to contain_file('/etc/init/giraffe.conf').with(:content => /pre-start script/ )
      end
    end

    context 'with aliases' do
      let(:params) do
        {
          :port => '8000',
          :app_type => 'rack',
          :vhost_aliases => ['foo','bar'],
          :domain => 'example.com',
          :vhost_full => 'giraffe.example.com',
        }
      end

      it { is_expected.to contain_nginx__config__vhost__proxy('giraffe.example.com').with_aliases(['foo','bar']) }
    end

    context 'without vhost' do
      let(:params) do
        {
          :port => '8000',
          :app_type => 'rack',
          :domain => 'example.com',
          :vhost_full => 'giraffe.example.com',
          :enable_nginx_vhost => false,
        }
      end

      it { is_expected.not_to contain_nginx__config__vhost__proxy('giraffe.example.com') }
    end

    context 'with unicorn_herder_timeout and app_type rack' do
      let(:params) do
        {
          :port => '8000',
          :app_type => 'rack',
          :domain => 'example.com',
          :vhost_full => 'giraffe.example.com',
          :unicorn_herder_timeout => '60'
        }
      end

      it do
        is_expected.to contain_govuk__app__envvar('giraffe-UNICORN_HERDER_TIMEOUT').with(
          :varname => 'UNICORN_HERDER_TIMEOUT',
          :value   => '60'
        )
      end
    end

    context 'with app_type => bare, command => ./launch_zoo' do
      let(:params) {{
        :port => '123',
        :app_type => 'bare',
        :domain => 'example.com',
        :vhost_full => 'giraffe.example.com',
        :command => './launch_zoo',
      }}

      it do
        is_expected.to contain_govuk__app__envvar('giraffe-GOVUK_APP_CMD').with(
          :varname => 'GOVUK_APP_CMD',
          :value   => './launch_zoo'
        )
      end

      it do
        is_expected.to contain_collectd__plugin__process('app-giraffe').with(
          :regex => '\\./launch_zoo$'
        )
      end
    end

    context 'with asset_pipeline => true' do
      let(:params) do
        {
          :port => '8000',
          :app_type => 'rack',
          :vhost_full => 'giraffe.example.com',
          :domain => 'example.com',
          :asset_pipeline => true,
        }
      end

      it do
        is_expected.to contain_nginx__config__vhost__proxy('giraffe.example.com').with(:extra_config => %r{location \^~ /assets/})
      end
    end

    context 'with asset_pipeline => true, asset_pipeline_prefixes => ["giraffe_assets"]' do
      let(:params) do
        {
          :port => '8000',
          :app_type => 'rack',
          :vhost_full => 'giraffe.example.com',
          :domain => 'example.com',
          :asset_pipeline => true,
          :asset_pipeline_prefixes => ['giraffe_assets'],
        }
      end

      it do
        is_expected.to contain_nginx__config__vhost__proxy('giraffe.example.com').with(:extra_config => %r{location \^~ /giraffe_assets/})
      end
    end

    context 'with asset_pipeline enabled and nginx_extra_config' do
      let(:params) do
        {
          :port => '8000',
          :app_type => 'rack',
          :vhost_full => 'giraffe.example.com',
          :domain => 'example.com',
          :nginx_extra_config => 'some_extra_config',
          :asset_pipeline => true,
        }
      end

      it do
        is_expected.to contain_nginx__config__vhost__proxy('giraffe.example.com').with(:extra_config => %r{location \^~ /assets/.*\n\nsome_extra_config}m)
      end
    end

    context 'when govuk_app_enable_services is false' do
      let(:params) {{
        :port => '8000',
        :app_type => 'rack',
        :domain => 'foo.bar.baz',
        :vhost_full => 'giraffe.foo.bar.baz',
      }}

      it "should set the upstart job to manual" do
        is_expected.to contain_file('/etc/init/giraffe.conf').with(
          # 'manual' stanza has to come after 'start on'
          :content => /start on.*^manual/m
        )
      end
    end
  end

  context 'title is big.giraffe' do
    let(:title) { 'big.giraffe' }

    context 'with good params' do
      let(:params) do
        {
          :port => '8000',
          :app_type => 'rack',
          :domain => 'foo.bar.baz',
          :vhost_full => 'big.giraffe.foo.bar.baz',
        }
      end

      it do
        is_expected.to contain_file('/etc/init/big.giraffe.conf')
        is_expected.to contain_nginx__config__vhost__proxy('big.giraffe.foo.bar.baz')
      end

      it do
        is_expected.to contain_collectd__plugin__process('app-big_giraffe')
      end
    end
  end
end
