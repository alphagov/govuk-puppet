# == Define: govuk::apps::ckan::ckan_cronjob
#
# Creates a cronjob entry specifically for ckan commands
#
# === Parameters
#
# [*hour*]
# [*minute*]
# [*month*]
# [*monthday*]
# [*weekday*]
# Same timing parameters as a normal cronjob
#
# [*ckan_command*]
# CKAN command to run eg "archiver update"
#
# [*timeout*]
# Duration after which to terminate command. See man 1 timeout for
# possible values.
#
define govuk::apps::ckan::ckan_cronjob (
  $ensure = present,
  $hour = undef,
  $minute = undef,
  $month = undef,
  $monthday = undef,
  $weekday = undef,
  $ckan_command = undef,
  $timeout = undef,
  $ckan_ini = '/var/ckan/ckan29.ini',
) {
  validate_string($ckan_command)

  if $ckan_ini {
    $ckan_config_arg = "-c ${ckan_ini}"
  } else {
    $ckan_config_arg = ''
  }

  if $timeout {
    $timeout_cmd = "/usr/bin/timeout ${timeout}"
  } else {
    $timeout_cmd = ''
  }

  cron { $title:
    ensure   => $ensure,
    command  => "cd /var/apps/ckan; ${timeout_cmd} ./venv3/bin/ckan ${ckan_config_arg} ${ckan_command}",
    user     => 'deploy',
    hour     => $hour,
    minute   => $minute,
    month    => $month,
    monthday => $monthday,
    weekday  => $weekday,
  }
}
