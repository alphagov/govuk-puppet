require_relative '../../../../spec_helper'

describe 'postgres', :type => :class do
  it do
    should contain_package("postgresql-9.1")
    should contain_file("/etc/postgresql/9.1/main/postgresql.conf")
    should contain_service("postgresql")
  end
end
