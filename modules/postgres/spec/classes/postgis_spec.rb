require_relative '../../../../spec_helper'

describe 'postgres::postgis', :type => :class do
  it { should contain_package("postgis") }
end
