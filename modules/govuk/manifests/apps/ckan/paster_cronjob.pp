# == Define: govuk::apps::ckan::paster_cronjob
#
# Creates a cronjob entry specifically for paster commands
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
# [*plugin*]
# Paster plugin to use
#
# [*paster_command*]
# Paster command to run eg "archiver update"
#
define govuk::apps::ckan::paster_cronjob (
  $ensure = present,
  $hour = undef,
  $minute = undef,
  $month = undef,
  $monthday = undef,
  $weekday = undef,
  $plugin = undef,
  $paster_command = undef,
  $ckan_ini = '/var/ckan/ckan.ini',
) {
  validate_string($plugin, $paster_command)

  if $ckan_ini {
    $ckan_config_arg = "--config=${ckan_ini}"
  } else {
    $ckan_config_arg = ''
  }

  cron { $title:
    ensure   => $ensure,
    command  => "cd /var/apps/ckan; ./venv/bin/paster --plugin=${plugin} ${paster_command} ${ckan_config_arg}",
    user     => 'deploy',
    hour     => $hour,
    minute   => $minute,
    month    => $month,
    monthday => $monthday,
    weekday  => $weekday,
  }
}
