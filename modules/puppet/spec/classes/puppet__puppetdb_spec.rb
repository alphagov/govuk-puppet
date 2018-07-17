require_relative '../../../../spec_helper'

describe 'puppet::puppetdb', :type => :class do
  it do
    is_expected.to contain_package('puppetdb')
    is_expected.to contain_package('puppetdb-terminus')
    is_expected.to contain_file('/etc/puppetdb/conf.d/database.ini')
    is_expected.to contain_file('/etc/puppetdb/repl.ini')
    is_expected.to contain_service('puppetdb').with_ensure('running')
    is_expected.to contain_govuk_postgresql__db('puppetdb')
  end
end
