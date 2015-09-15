require_relative '../../../../spec_helper'

describe 'govuk::app', :type => :define do
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
        :port => 8000,
        :app_type => 'rack',
      }
    end

    it do
      is_expected.to contain_govuk__app__package('giraffe').with(
        'vhost_full' => 'giraffe.environment.example.com',
      )
      is_expected.to contain_govuk__app__config('giraffe').with(
        'domain' => 'environment.example.com',
      )
      is_expected.to contain_service('giraffe').with_provider('upstart')
    end

    it "should not hide any paths" do
      is_expected.to contain_govuk__app__nginx_vhost('giraffe').with(
        'hidden_paths' => []
      )
    end
  end

  context 'app_type => bare, without command' do
    let(:params) {{
      :app_type => 'bare',
      :port     => 123,
    }}

    it { is_expected.to raise_error(Puppet::Error, /Invalid \$command parameter/) }
  end

  describe 'app_type => bare, which logs JSON to STDERR' do
    let(:params) {{
      :app_type           => 'bare',
      :port               => 123,
      :command            => '/bin/yes',
      :log_format_is_json => true,
    }}

    it { is_expected.to contain_govuk__logstream("#{title}-app-err").with("json" => true) }
  end

  context 'health check hidden' do
    let(:params) do
      {
        :app_type => 'rack',
        :port => 8000,
        :health_check_path => '/healthcheck',
        :expose_health_check => false,
      }
    end

    it "should hide the healthcheck paths" do
      is_expected.to contain_govuk__app__nginx_vhost('giraffe').with(
        'hidden_paths' => ['/healthcheck']
      )
    end
  end

  context 'health check path not provided, health check hidden' do
    let(:params) do
      {
        :app_type => 'rack',
        :port => 8000,
        :expose_health_check => false,
      }
    end

    it "should fail to compile" do
      is_expected.to raise_error(Puppet::Error, /Cannot hide/)
    end
  end

  context 'with ensure' do
    context 'ensure => absent' do
      let(:params) {{
        :app_type => 'rack',
        :port => 8000,
        :ensure => 'absent',
      }}

      it do
        is_expected.to contain_govuk__app__package('giraffe').with_ensure('absent')
      end
    end

    context 'ensure => true' do
      let(:params) {{
        :app_type => 'rack',
        :port => 8000,
        :ensure => 'true',
      }}

      it { is_expected.to raise_error(Puppet::Error, /Invalid ensure value/) }
    end

    context 'ensure => false' do
      let(:params) {{
        :app_type => 'rack',
        :port => 8000,
        :ensure => 'false',
      }}

      it { is_expected.to raise_error(Puppet::Error, /Invalid ensure value/) }
    end
  end
end
