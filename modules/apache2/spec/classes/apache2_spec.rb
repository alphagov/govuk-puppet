require_relative '../../../../spec_helper'

describe 'apache2', :type => :class do
  it { should create_package("apache2") }
end
