# Class: monitoring::checks::smokey
#
# Nagios checks based on Smokey (cucumber HTTP tests). smokey-nagios runs
# periodically and writes the results to a JSON file atomically. That output
# is read by Nagios for each of the check_feature resources.
#
# === Parameters
#
# [*features*]
#   A hash of features that should be executed by Icinga.
#
class monitoring::checks::smokey (
  $features = {}
) {
  validate_hash($features)

  # TODO: Should this really run as root?
  file { '/etc/init/smokey-nagios.conf':
    ensure => present,
    source => 'puppet:///modules/monitoring/etc/init/smokey-nagios.conf',
  }

  service { 'smokey-nagios':
    ensure   => running,
    provider => 'upstart',
    require  => File['/etc/init/smokey-nagios.conf'],
  }

  create_resources(icinga::check_feature, $features)

}
