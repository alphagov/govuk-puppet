require_relative '../../../../spec_helper'

describe 'resolvconf::config', :type => :class do
  let(:file_path) { '/etc/resolvconf/resolv.conf.d/head' }

  context 'dhcp_enabled true' do
    let(:facts) {{ :dhcp_enabled => 'true' }}
    let(:params) {{ :nameservers => ['1.1.1.1', '2.2.2.2'] }}

    it { should_not contain_file(file_path).with_content(/^nameserver/) }
  end

  context 'dhcp_enabled false' do
    let(:facts) {{ :dhcp_enabled => 'false' }}

    context 'nameservers => []' do
      let(:params) {{ :nameservers => [] }}

      it { should_not contain_file(file_path).with_content(/^nameserver/) }
    end

    [
      '1.1.1.1',
      ['1.1.1.1'],
    ].each do |param|
      context "nameservers => #{param.inspect}" do
        let(:params) {{ :nameservers => param }}

        it { should contain_file(file_path).with_content(/^nameserver 1.1.1.1$/) }
      end
    end

    [
      '1.1.1.1 2.2.2.2',
      ['1.1.1.1', '2.2.2.2']
    ].each do |param|
      context "nameservers => #{param.inspect}" do
        let(:params) {{ :nameservers => param }}

        it { should contain_file(file_path)
          .with_content(/^nameserver 1.1.1.1\nnameserver 2.2.2.2$/)
        }
      end
    end
  end
end
