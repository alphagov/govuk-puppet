require_relative '../../../../spec_helper'

describe 'monitoring::checks::mirror', :type => :class do
  let(:pre_condition) {
    'icinga::host { "dummy.host": }'
  }
  let(:facts) {{
    :fqdn       => "dummy.host",
    :cache_bust => Time.now,
  }}

  context 'checks enabled with hiera' do
    let(:params) {{
      'enabled' => true,
    }}
    it { should contain_icinga__check_config('mirror_age') }
    it { should contain_icinga__check('check_mirror0_provider0_up_to_date') }
    it { should contain_icinga__check('check_mirror1_provider0_up_to_date') }
    it { should contain_icinga__check('check_mirror0_provider1_up_to_date') }
    it { should contain_icinga__check('check_mirror1_provider1_up_to_date') }
end

  context 'checks disabled with hiera (default)' do
    let(:params) {{
      'enabled' => false,
    }}
    it { should contain_icinga__check_config('mirror_age') }
    it { should_not contain_icinga__check('check_mirror0_provider0_up_to_date') }
    it { should_not contain_icinga__check('check_mirror1_provider0_up_to_date') }
    it { should_not contain_icinga__check('check_mirror0_provider1_up_to_date') }
    it { should_not contain_icinga__check('check_mirror1_provider0_up_to_date') }
  end
end
