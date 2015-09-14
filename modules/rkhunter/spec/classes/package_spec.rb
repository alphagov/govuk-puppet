require_relative '../../../../spec_helper'

describe 'rkhunter::package', :type => :class do
  it { is_expected.to contain_package('rkhunter') }
end
