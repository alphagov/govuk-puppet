require_relative '../../../../spec_helper'

describe 'monitoring::checks::mirror', :type => :class do
  let(:pre_condition) {
    'nagios::host { "dummy.host": }'
  }
  let(:facts) {{
    :fqdn       => "dummy.host",
    :cache_bust => Time.now,
  }}

  context 'checks enabled with extdata' do
    before(:each) { update_extdata("mirror_enable_checks" => "yes") }

    it { should contain_nagios__check_config('mirror_age') }
    it { should contain_nagios__check('check_mirror0_up_to_date') }
    it { should contain_nagios__check('check_mirror1_up_to_date') }
  end

  context 'checks disabled with extdata (default)' do
    before(:each) { update_extdata("mirror_enable_checks" => "no") }

    it { should contain_nagios__check_config('mirror_age') }
    it { should_not contain_nagios__check('check_mirror0_up_to_date') }
    it { should_not contain_nagios__check('check_mirror1_up_to_date') }
  end
end
