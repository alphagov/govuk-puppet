require_relative '../../../../spec_helper'

describe 'postfix::package', :type => :class do
  it { is_expected.to contain_package('postfix') }
end
