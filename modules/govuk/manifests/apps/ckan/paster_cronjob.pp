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
) {

  validate_string($plugin, $paster_command)

  cron { $title:
    ensure   => $ensure,
    command  => "cd /var/apps/ckan; ./venv/bin/paster --plugin=${plugin} ${paster_command} --config=/var/ckan/ckan.ini",
    user     => 'deploy',
    hour     => $hour,
    minute   => $minute,
    month    => $month,
    monthday => $monthday,
    weekday  => $weekday,
  }
}
