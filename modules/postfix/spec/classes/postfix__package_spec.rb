require_relative '../../../../spec_helper'

describe 'postfix::package', :type => :class do
  it { should contain_package('postfix') }
end
