require_relative '../../../../spec_helper'

describe 'monitoring::checks::mirror', :type => :class do
  let(:pre_condition) {
    'icinga::host { "dummy.host": }'
  }
  let(:facts) {{
    :fqdn       => "dummy.host",
    :cache_bust => Time.now,
    :ipaddress  => '10.10.10.10',
    :fqdn_short => 'fakehost-1.management',
  }}

  context 'checks enabled with hiera' do
    let(:params) {{
      'enabled' => true,
    }}
    it { is_expected.to contain_icinga__check_config('mirror_age') }
    it { is_expected.to contain_icinga__check('check_mirror0_provider0_up_to_date') }
    it { is_expected.to contain_icinga__check('check_mirror1_provider0_up_to_date') }
    it { is_expected.to contain_icinga__check('check_mirror0_provider1_up_to_date') }
    it { is_expected.to contain_icinga__check('check_mirror1_provider1_up_to_date') }
end

  context 'checks disabled with hiera (default)' do
    let(:params) {{
      'enabled' => false,
    }}
    it { is_expected.to contain_icinga__check_config('mirror_age') }
    it { is_expected.not_to contain_icinga__check('check_mirror0_provider0_up_to_date') }
    it { is_expected.not_to contain_icinga__check('check_mirror1_provider0_up_to_date') }
    it { is_expected.not_to contain_icinga__check('check_mirror0_provider1_up_to_date') }
    it { is_expected.not_to contain_icinga__check('check_mirror1_provider0_up_to_date') }
  end
end
