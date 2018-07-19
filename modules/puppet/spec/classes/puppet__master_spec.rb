require_relative '../../../../spec_helper'

describe 'puppet::master', :type => :class do
  # concat_basedir needed for puppetdb module (for postgresql)
  let(:facts) {{
    :concat_basedir => '/var/lib/puppet/concat/',
    :id             => 'root',
    :path           => 'concatted_file',
  }}

  it do
    is_expected.to contain_file('/etc/init/puppetmaster.conf').
      with_content(/unicornherder -u unicorn -p \$PIDFILE -- -p 9090 -c \/etc\/puppet\/unicorn.conf/)
    is_expected.to contain_service('puppetmaster').with_provider('upstart').with_ensure('running')
  end

  it {
    is_expected.to contain_package('puppetdb')
    is_expected.to contain_package('puppetdb-terminus')
    is_expected.to contain_exec('puppetdb ssl-setup')
      .with_command('/usr/sbin/puppetdb-ssl-setup')
      .that_requires('Class[puppet::master::generate_cert]')
    is_expected.to contain_exec('disable-default-puppetdb')
    is_expected.to contain_file('/etc/init/puppetdb.conf')
    is_expected.to contain_govuk_postgresql__db('puppetdb')
    is_expected.to contain_file('/etc/init/puppetdb.conf').with_content(/-Xmx1024m/)
    is_expected.to contain_file('/etc/puppetdb/conf.d/database.ini')
    is_expected.to contain_file('/etc/puppetdb/conf.d/config.ini').with_content(/log4j.properties/)
    is_expected.to contain_file('/etc/puppetdb/conf.d/repl.ini')
  }

  it { is_expected.to contain_class('puppet::master::nginx') }

  it do
    is_expected.to contain_class('puppet')
    is_expected.to contain_class('puppet::master::config')
    is_expected.to contain_file('/etc/puppet/config.ru')
  end
end
