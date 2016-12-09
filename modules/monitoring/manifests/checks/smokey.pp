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
# [*environment*]
#   String to pass to the tests_json_output.sh script, e.g. integration
#
class monitoring::checks::smokey (
  $features = {},
  $environment = '',
) {
  validate_hash($features)

  $service_file = '/etc/init/smokey-loop.conf'

  # TODO: Should this really run as root?
  file { $service_file:
    ensure  => present,
    content => template('monitoring/smokey-loop.conf'),
  }

  service { 'smokey-loop':
    ensure   => running,
    provider => 'upstart',
    require  => File[$service_file],
  }

  create_resources(icinga::check_feature, $features)

}
