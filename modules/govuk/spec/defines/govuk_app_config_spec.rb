require_relative '../../../../spec_helper'

describe 'govuk::app::config', :type => :define do
  context 'title is giraffe' do
    let(:title) { 'giraffe' }

    context 'with no params' do
      it do
        expect {
          should contain_file('/var/apps/giraffe')
        }.to raise_error(Puppet::Error, /Must pass app_type/)
      end
    end

    context 'with good params' do
      let(:params) do
        {
          :port => 8000,
          :app_type => 'rack',
          :domain => 'foo.bar.baz',
          :vhost_full => 'giraffe.foo.bar.baz',
        }
      end

      it do
        should contain_file('/etc/init/giraffe.conf')
        should contain_nginx__config__vhost__proxy('giraffe.foo.bar.baz')
      end

      it do
        should contain_collectd__plugin__process('app-giraffe').with(
          :regex => /^unicorn .* -P \/var\/run\/giraffe\/app\\.pid$/
        )
      end

      it do
        should_not contain_govuk__app__envvar('giraffe-UNICORN_HERDER_TIMEOUT')
      end

      it do
        should_not contain_file('/etc/init/giraffe.conf').with(
          :content => /post-start script/
        )
      end
    end

    context 'with aliases' do
      let(:params) do
        {
          :port => 8000,
          :app_type => 'rack',
          :vhost_aliases => ['foo','bar'],
          :domain => 'example.com',
          :vhost_full => 'giraffe.example.com',
        }
      end

      it { should contain_nginx__config__vhost__proxy('giraffe.example.com').with_aliases(['foo.example.com','bar.example.com']) }
    end

    context 'without vhost' do
      let(:params) do
        {
          :port => 8000,
          :app_type => 'rack',
          :domain => 'example.com',
          :vhost_full => 'giraffe.example.com',
          :enable_nginx_vhost => false,
        }
      end

      it { should_not contain_nginx__config__vhost__proxy('giraffe.example.com') }
    end

    context 'with intercept_errors true' do
      let(:params) do
        {
          :port => 8000,
          :app_type => 'rack',
          :domain => 'example.com',
          :vhost_full => 'giraffe.example.com',
          :intercept_errors => true,
        }
      end

      it do
        should contain_nginx__config__vhost__proxy('giraffe.example.com')
          .with_intercept_errors(true)
      end
    end

    context 'with unicorn_herder_timeout and app_type rack' do
      let(:params) do
        {
          :port => 8000,
          :app_type => 'rack',
          :domain => 'example.com',
          :vhost_full => 'giraffe.example.com',
          :unicorn_herder_timeout => 60
        }
      end

      it do
        should contain_govuk__app__envvar('giraffe-UNICORN_HERDER_TIMEOUT').with(
          :varname => 'UNICORN_HERDER_TIMEOUT',
          :value   => 60
        )
      end
    end

    context 'with app_type => bare, command => ./launch_zoo' do
      let(:params) {{
        :port => 123,
        :app_type => 'bare',
        :domain => 'example.com',
        :vhost_full => 'giraffe.example.com',
        :command => './launch_zoo',
      }}

      it do
        should contain_govuk__app__envvar('giraffe-GOVUK_APP_CMD').with(
          :varname => 'GOVUK_APP_CMD',
          :value   => './launch_zoo'
        )
      end

      it do
        should contain_collectd__plugin__process('app-giraffe').with(
          :regex => '^\\./launch_zoo$'
        )
      end
    end

    context 'with an upstart post-start script' do
      let(:params) do
        {
          :port => 8000,
          :app_type => 'rack',
          :domain => 'foo.bar.baz',
          :vhost_full => 'giraffe.foo.bar.baz',
          :upstart_post_start_script => '/bin/true',
        }
      end

      it do
        should contain_file('/etc/init/giraffe.conf').with(:content => %r{post-start script\s*\n\s*/bin/true\s*\n\s*end script})
      end
    end
  end

  context 'title is big.giraffe' do
    let(:title) { 'big.giraffe' }

    context 'with good params' do
      let(:params) do
        {
          :port => 8000,
          :app_type => 'rack',
          :domain => 'foo.bar.baz',
          :vhost_full => 'big.giraffe.foo.bar.baz',
        }
      end

      it do
        should contain_file('/etc/init/big.giraffe.conf')
        should contain_nginx__config__vhost__proxy('big.giraffe.foo.bar.baz')
      end

      it do
        should contain_collectd__plugin__process('app-big_giraffe')
      end
    end
  end
end
