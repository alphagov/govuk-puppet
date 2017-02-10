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
        :port => '8000',
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

  context 'health check hidden' do
    let(:params) do
      {
        :app_type => 'rack',
        :port => '8000',
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

  describe "logging" do
    let(:params) {{
      :app_type => 'rack',
      :port => '8000',
    }}

    context "a 12-factor app" do
      before :each do
        params[:legacy_logging] = false
      end

      it "collects stdout logging as JSON" do
        expect(subject).to contain_govuk_logging__logstream("#{title}-app-out")
          .with_logfile("/var/log/#{title}/app.out.log")
          .with_json(true)
      end

      it "collects stderr logging as plain text" do
        expect(subject).to contain_govuk_logging__logstream("#{title}-app-err")
          .with_logfile("/var/log/#{title}/app.err.log")
          .with_json(false)
      end

      it "removes collection of the apps production.log" do
        expect(subject).to contain_govuk_logging__logstream("#{title}-production-log")
          .with_ensure("absent")
      end
    end

    context "a non-12-factor app" do
      before :each do
        params[:legacy_logging] = true
      end

      it "collects stderr logging as plain text" do
        expect(subject).to contain_govuk_logging__logstream("#{title}-app-err")
          .with_logfile("/var/log/#{title}/app.err.log")
          .with_json(false)
      end

      it "collects the app production.log as plain text by default" do
        expect(subject).to contain_govuk_logging__logstream("#{title}-production-log")
          .with_logfile("/data/vhost/#{title}.environment.example.com/shared/log/production.log")
          .with_json(false)
      end

      it "collects the app production.json.log as JSON when requested" do
        params[:log_format_is_json] = true

        expect(subject).to contain_govuk_logging__logstream("#{title}-production-log")
          .with_logfile("/data/vhost/#{title}.environment.example.com/shared/log/production.json.log")
          .with_json(true)
      end

      describe 'app_type => bare, which logs JSON to STDERR' do

        it "collects stderr as JSON" do
          params.update(
            :app_type           => 'bare',
            :command            => '/bin/yes',
            :log_format_is_json => true,
          )

          expect(subject).to contain_govuk_logging__logstream("#{title}-app-err")
            .with_logfile("/var/log/#{title}/app.err.log")
            .with("json" => true)
        end
      end

    end
  end
end
