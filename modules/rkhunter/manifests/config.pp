# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class rkhunter::config (
  $ensure = 'present',
) {

  $disabled_tests = [
    'apps',
    'deleted_files',
    'filesystem',
    'group_changes',
    'hidden_procs',
    'packet_cap_apps',
    'passwd_changes',
    'ports',
    'properties',
    'running_procs',
    'suspscan',
  ]

  file { '/etc/default/rkhunter':
    ensure => $ensure,
    source => 'puppet:///modules/rkhunter/etc/default/rkhunter',
  }

  file { '/etc/rkhunter.conf.local':
    ensure  => $ensure,
    content => template('rkhunter/rkhunter.conf.local.erb'),
  }

}
