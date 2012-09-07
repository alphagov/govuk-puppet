require_relative '../../../../spec_helper'

describe 'rkhunter::package', :type => :class do
  it { should contain_package('rkhunter') }
end
