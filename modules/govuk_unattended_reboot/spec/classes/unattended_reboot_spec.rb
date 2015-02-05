require_relative '../../../../spec_helper'

describe 'govuk_unattended_reboot', :type => :class do
  let(:facts) {{
    :fqdn             => 'foo.example.com',
    :govuk_node_class => 'chocolate_factory',
  }}

  describe "enabled" do
    let(:params) {{
      :enabled => true,
      :etcd_endpoints => ['http://etcd-1.foo:4001', 'http://etcd-2.foo:4001'],
    }}

    it { should contain_file('/etc/init/post-reboot-unlock.conf').with_ensure('present') }
    it { should contain_file('/usr/local/bin/unattended-reboot').with_ensure('present') }
    it { should contain_file('/usr/local/bin/check_icinga').with_ensure('present') }
    it { should contain_file('/etc/logrotate.d/unattended_reboot').with_ensure('present') }

    it { should contain_cron('unattended-reboot').with_ensure('present') }

    it "passes the first endpoint only to locksmithctl" do
      should contain_file('/usr/local/bin/unattended-reboot').with_content(/locksmithctl -endpoint='http:\/\/etcd-1\.foo:4001' lock/)
    end

    it "correctly formats the node class when querying Icinga" do
      should contain_file('/usr/local/bin/unattended-reboot').with_content(/status.cgi\?search_string=chocolate-factory&/)
    end

    it "uses the correct FQDN when obtaining the reboot mutex" do
      should contain_file('/usr/local/bin/unattended-reboot').with_content(/locksmithctl.*lock 'foo\.example\.com'/)
    end
  end

  describe "disabled" do
    let(:params) {{
      :enabled => false,
    }}

    it { should contain_file('/etc/init/post-reboot-unlock.conf').with_ensure('absent') }
    it { should contain_file('/usr/local/bin/unattended-reboot').with_ensure('absent') }
    it { should contain_file('/usr/local/bin/check_icinga').with_ensure('absent') }
    it { should contain_file('/etc/logrotate.d/unattended_reboot').with_ensure('absent') }

    it { should contain_cron('unattended-reboot').with_ensure('absent') }
  end

  describe "enabled but empty array passed to etcd_endpoints" do
    let(:params) {{
      :enabled => true,
      :etcd_endpoints => [],
    }}

    it { expect { should }.to raise_error(Puppet::Error, /^Must pass non-empty array/) }
  end

end
