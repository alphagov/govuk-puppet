require_relative '../../../../spec_helper'

describe 'govuk_datascrubber', :type => :class do
  it { is_expected.to contain_package('govuk-datascrubber') }
  it { is_expected.to contain_cron('datascrubber') }
  it { is_expected.to contain_govuk_datascrubber__icinga_check('whitehall') }
  it { is_expected.to contain_govuk_datascrubber__icinga_check('email-alert-api') }
  it { is_expected.to contain_govuk_datascrubber__icinga_check('publishing-api') }
end
