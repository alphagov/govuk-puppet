# Class: monitoring::checks::smokey
#
# Monitoring checks based on Smokey (cucumber HTTP tests). smokey-loop runs
# constantly and writes the results to a JSON file atomically. That output
# is read by Icinga for each of the check_feature resources.
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

  # FIXME: Remove once deployed to production
  service { 'smokey-nagios':
    ensure => stopped,
  } ->
  file { '/etc/init/smokey-nagios.conf':
    ensure => absent,
  }

  $service_file = '/etc/init/smokey-loop.conf'

  # TODO: Should this really run as root?
  file { $service_file:
    ensure => present,
    source => "puppet:///modules/monitoring${service_file}",
  }

  service { 'smokey-loop':
    ensure   => running,
    provider => 'upstart',
    require  => File[$service_file],
  }

  create_resources(icinga::check_feature, $features)

}
