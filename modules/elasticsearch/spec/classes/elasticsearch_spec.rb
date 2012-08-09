require_relative '../../../../spec_helper'

describe 'elasticsearch', :type => :class do
  it { should contain_package('elasticsearch') }
end
