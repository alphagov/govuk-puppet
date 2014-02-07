require_relative '../../../../spec_helper'

describe 'ssh::config', :type => :class do
  let(:ssh_conf) { '/etc/ssh/sshd_config' }

  describe '#allow_users and #allow_users_enable' do
    context 'false (default)' do
      it { should contain_file(ssh_conf).without_content(/AllowUsers/) }
    end

    context 'true, default allow_users' do
      let(:params) {{
        :allow_users_enable => true,
      }}

      it { should contain_file(ssh_conf).with_content(/^AllowUsers \*$/) }
    end

    context 'true, array for allow_users' do
      let(:params) {{
        :allow_users        => ['simple', 'simon', 'says'],
        :allow_users_enable => true,
      }}

      it { should contain_file(ssh_conf).with_content(/^AllowUsers simple simon says$/) }
    end
  end

  describe '#allow_x11_forwarding' do
    context 'false (default)' do
      it { should contain_file(ssh_conf).with_content(/^X11Forwarding\s+no$/) }
    end

    context 'true' do
      let(:params) {{
        :allow_x11_forwarding => true,
      }}

      it { should contain_file(ssh_conf).with_content(/^X11Forwarding\s+yes$/) }
    end
  end
end
