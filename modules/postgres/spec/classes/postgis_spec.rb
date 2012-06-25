require_relative '../../../../spec_helper'

describe 'postgres::postgis', :type => :class do
  let(:facts) { { :lsbdistcodename => 'precise' } }
  it { should contain_package("postgresql-9.1-postgis" ) }
end
