require_relative '../../../../spec_helper'

describe 'icinga::host', :type => :define do
  let(:title) { 'bruce-forsyth' }

  let(:facts) {{
    :ipaddress  => '10.10.10.10',
    :fqdn_short => 'fakehost-1.management',
  }}

  it { is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_bruce-forsyth.cfg') }
  it { is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_bruce-forsyth.cfg').without_content(/parents/) }

  it { is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_bruce-forsyth.cfg').with_content(/notification_period\s+24x7/) }

  context 'Host parents required' do
    let(:params) {{
      'parents' => 'vpn_gateway_test'
    }}

    shared_examples 'a host with parents' do
      it { is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_bruce-forsyth.cfg').with_content(/parents\s+vpn_gateway_test/) }
    end

    describe 'On a DR machine' do
      let(:facts) {{
        'vdc' => 'test_dr',
      }}

      it_behaves_like 'a host with parents'
    end

    describe 'On a Licensify machine' do
      let(:facts) {{
        'vdc' => 'licensify',
      }}

      it_behaves_like 'a host with parents'
    end

    describe 'On an EFG machine' do
      let(:facts) {{
        'vdc' => 'efg',
      }}

      it_behaves_like 'a host with parents'
    end
  end
end
