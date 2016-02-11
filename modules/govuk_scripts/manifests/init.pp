# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_scripts {

  # govuk_node_list is a simple script that lists nodes of specified classes
  # using puppetdb
  file { '/usr/local/bin/govuk_node_list':
    ensure => present,
    source => 'puppet:///modules/govuk_scripts/usr/local/bin/govuk_node_list',
    mode   => '0755',
  }

  # govuk_node_clean removes stale or decommissioned nodes from puppetdb and the
  # puppetmaster
  file { '/usr/local/bin/govuk_node_clean':
    ensure => present,
    source => 'puppet:///modules/govuk_scripts/usr/local/bin/govuk_node_clean',
    mode   => '0755',
  }

  # govuk_check_security_upgrades list packages which need a security upgrade
  file { '/usr/local/bin/govuk_check_security_upgrades':
    ensure => present,
    #FIXME Needs updating when precise is no longer used
    source => "puppet:///modules/govuk_scripts/usr/local/bin/govuk_check_security_upgrades_${::lsbdistcodename}",
    mode   => '0755',
  }

}
