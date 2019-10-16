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
  $disable_during_data_sync = false,
) {
  validate_hash($features)

  $service_file = '/etc/init/smokey-loop.conf'

  include govuk::apps::smokey

  user { 'smokey':
    ensure     => present,
    name       => 'smokey',
    managehome => true,
    shell      => '/bin/bash',
    system     => true,
  }

  file { $service_file:
    ensure  => present,
    content => template('monitoring/smokey-loop.conf'),
    require => Class['govuk::apps::smokey'],
  }

  if $disable_during_data_sync and $::data_sync_in_progress {
    $service_ensure = stopped
    $icinga_ensure = absent
  } else {
    $service_ensure = running
    $icinga_ensure = present
  }

  service { 'smokey-loop':
    ensure   => $service_ensure,
    provider => 'upstart',
    require  => File[$service_file],
  }

  if $disable_during_data_sync {
    govuk_data_sync_in_progress { 'smokey':
      start_command  => 'sudo initctl stop smokey-loop',
      finish_command => 'sudo initctl start smokey-loop',
    }
  }

  create_resources(icinga::check_feature, $features, {
    'ensure' => $icinga_ensure,
    'notes_url' => monitoring_docs_url(high-priority-tests),
  })
}
