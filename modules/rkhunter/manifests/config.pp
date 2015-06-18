# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class rkhunter::config {

  $disabled_tests = [
    'apps',
    'deleted_files',
    'filesystem',
    'hidden_procs',
    'packet_cap_apps',
    'properties',
    'running_procs',
    'suspscan',
  ]

  file { '/etc/default/rkhunter':
    ensure => 'present',
    source => 'puppet:///modules/rkhunter/etc/default/rkhunter',
  }

  file { '/etc/rkhunter.conf.local':
    ensure  => 'present',
    content => template('rkhunter/rkhunter.conf.local.erb'),
  }

}
