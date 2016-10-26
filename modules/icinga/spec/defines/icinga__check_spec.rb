require_relative '../../../../spec_helper'

# icinga::check should create file in correct place using host_name param
describe 'icinga::check', :type => :define do
  let(:pre_condition) {
    'icinga::host{"bruce-forsyth":}'
  }
  let(:param_defaults) {{
    :check_command       => "nice-to-see-you",
    :host_name           => "bruce-forsyth",
    :service_description => "to see you nice",
  }}
  let(:facts) {{
    :ipaddress  => '10.10.10.10',
    :fqdn_short => 'fakehost-1.management',
  }}

  context "validating service description" do
    context "when service description is valid" do
      let(:title) { 'heartbeat' }
      let(:params) { param_defaults }

      it "should not raise an error" do
        expect { subject.call }.to_not raise_error()
      end
    end

    context "when service description is invalid" do
      let(:title) { 'heartbeat' }
      let(:params) { param_defaults.merge({
        :service_description => "invalid()nonsense||",
      })}

      it "should be detected" do
        expect { subject.call }.to raise_error(Puppet::Error, /invalid characters/)
      end
    end
  end

  context "should create file in correct location" do
    let(:title) { 'heartbeat' }
    let(:params) { param_defaults }

    it { is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_bruce-forsyth/heartbeat.cfg') }
  end

  context "should add max_check_attempts when attempts_before_hard_state passed in" do
    let(:title) { 'test_max_check_attempts' }
    let(:params) { param_defaults.merge({
      :attempts_before_hard_state => "1",
    })}

    it { is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_bruce-forsyth/test_max_check_attempts.cfg').
         with_content(/max_check_attempts\s+1/)
    }
  end

  context "should use govuk_regular_service by default" do
    let(:title) { 'default_service' }
    let(:params) { param_defaults.merge({
      :service_description => "has default service as regular",
    })}

    it { is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_bruce-forsyth/default_service.cfg').
         with_content(/use\s+govuk_regular_service/)
    }
  end

  context "should get in touch with a contact group" do
    let(:title) { 'default_service' }
    let(:params) { param_defaults.merge({
      :contact_groups => "wildlings",
    })}

    it { is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_bruce-forsyth/default_service.cfg').
         with_content(/contact_groups\s+\+wildlings/)
    }

  end

  [:action_url, :notes_url].each do |param|
    context param do
      let(:title) { 'bonus' }

      context "undef (default)" do
        let(:params) { param_defaults }

        it {
          is_expected.not_to contain_file('/etc/icinga/conf.d/icinga_host_bruce-forsyth/bonus.cfg').
            with_content(/#{param}/)
        }
      end

      context "https://graphite.example.com/render" do
        let(:params) { param_defaults.merge({
          param => "https://url.example.com/",
        })}

        it {
          is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_bruce-forsyth/bonus.cfg').
            with_content(/^\s*#{param}\s+https:\/\/url\.example\.com\/$/)
        }
      end
    end
  end

  context 'linked_metric overrides action_url' do
    let(:title) { 'linking_to_metrics' }
    let(:params) { param_defaults.merge({
      :action_url    => 'https://example.com/action-url',
      :linked_metric => 'stats.cache-1.nginx_logs.www-origin.http_200',
    })}

    it {
      is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_bruce-forsyth/linking_to_metrics.cfg').
        with_content(/^\s*action_url\s+https:\/\/graphite\.environment\.example\.com\/render\/\?width=\d+&height=\d+&target=stats.cache-1.nginx_logs.www-origin.http_200$/)
    }
  end
end
