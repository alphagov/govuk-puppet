require_relative '../../../../spec_helper'

describe 'icinga::timeperiod', :type => :define do
  let(:title) { 'whenjimisawake' }
  let(:params) {{ "timeperiod_alias" => "Not Often", "sun" => "00:00-24:00"}}
  it { is_expected.to contain_file('/etc/icinga/conf.d/timeperiod_whenjimisawake.cfg').
	  with_content(/timeperiod_name\s+whenjimisawake/).
	  with_content(/alias\s+Not Often/).
	  with_content(/sunday\s+00:00-24:00/)
    is_expected.not_to contain_file('/etc/icinga/conf.d/timeperiod_whenjimisawake.cfg').
	  with_content(/monday/)
  }
end
