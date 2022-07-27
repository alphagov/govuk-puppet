# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_scripts {

  # govuk_app_console: opens a console for a specified application
  file { '/usr/local/bin/govuk_app_console':
    ensure => present,
    source => 'puppet:///modules/govuk_scripts/usr/local/bin/govuk_app_console',
    mode   => '0755',
  }

  # govuk_app_dbconsole: opens a database console for a specified application
  file { '/usr/local/bin/govuk_app_dbconsole':
    ensure => present,
    source => 'puppet:///modules/govuk_scripts/usr/local/bin/govuk_app_dbconsole',
    mode   => '0755',
  }

  # govuk_check_security_upgrades list packages which need a security upgrade
  file { '/usr/local/bin/govuk_check_security_upgrades':
    ensure => present,
    source => "puppet:///modules/govuk_scripts/usr/local/bin/govuk_check_security_upgrades_${::lsbdistcodename}",
    mode   => '0755',
  }

  # govuk_node_clean removes stale or decommissioned nodes from puppetdb and the
  # puppetmaster
  file { '/usr/local/bin/govuk_node_clean':
    ensure => present,
    source => 'puppet:///modules/govuk_scripts/usr/local/bin/govuk_node_clean',
    mode   => '0755',
  }

  # govuk_node_list is a simple script that lists nodes of specified classes
  # using puppetdb. In AWS, we use tags to find the relevant hosts rather than
  # PuppetDB, except when we're searching for specific Puppet classes.
  package { 'boto3':
    ensure   => 'present',
    provider => 'pip',
    require  => File['/usr/bin/pip'],
  }

  # Make sure boto3 is installed for Python3 as required by govuk_node_list_aws
  exec { 'check_boto':
    path    => ['/usr/bin', '/usr/sbin'],
    command => '/usr/bin/pip3 install botocore==1.21.3 boto3==1.21.3 s3transfer==0.5.0',
    require => Class['base::packages'],
    unless  => 'test -d /usr/local/lib/python3.4/dist-packages/boto3-1.21.3.dist-info -a -d botocore-1.21.3.dist-info -a -d s3transfer-0.5.0.dist-info',
  }

  $app_domain_internal = hiera('app_domain_internal')

  file { '/usr/local/bin/govuk_node_list':
    ensure  => present,
    content => template('govuk_scripts/govuk_node_list_aws.erb'),
    mode    => '0755',
  }
}
