# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_scripts {

  # govuk_app_console: opens a console for a specified application
  file { '/usr/local/bin/govuk_app_console':
    ensure => present,
    source => 'puppet:///modules/govuk_scripts/usr/local/bin/govuk_app_console',
    mode   => '0755',
  }

  # govuk_check_security_upgrades list packages which need a security upgrade
  file { '/usr/local/bin/govuk_check_security_upgrades':
    ensure => present,
    #FIXME Needs updating when precise is no longer used
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
  if $::aws_migration {
    package { 'boto3':
      ensure   => 'present',
      provider => 'pip',
    }

    file { '/usr/local/bin/govuk_node_list':
      ensure  => present,
      content => template('govuk_scripts/govuk_node_list_aws.erb'),
      mode    => '0755',
    }
  } else {
    file { '/usr/local/bin/govuk_node_list':
      ensure => present,
      source => 'puppet:///modules/govuk_scripts/usr/local/bin/govuk_node_list',
      mode   => '0755',
    }
  }
}
