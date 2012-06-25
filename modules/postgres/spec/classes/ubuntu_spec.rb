require_relative '../../../../spec_helper'

describe 'postgres::ubuntu', :type => :class do
  let(:facts) { { :lsbdistcodename => 'precise' } }
  it { should contain_file("/etc/postgresql/9.1/main/postgresql.conf" ) }
end
