# == Define: Cron::Crondotdee
#
# Create a file in /etc/cron.d rather than in cron.daily or a shared crontab.
# Default behaviour is to set a command, minute and hour and to run as root.
#
# Note: set hour/minute/day/month/weekday as a string rather than an integer as
# they could potentially contain non-integer values, so keep it consistent.
#
# === Parameters:
#
# [*command*]
#   The command to schedule. Required.
#
# [*hour*]
#   The hour(s) to run.
#
# [*minute*]
#   The minute(s) to run.
#
# [*day*]
#   The day to run. Default is everyday.
#
# [*month*]
#   The month to run. Default is every month.
#
# [*weekday*]
#   The weekday to run. Default is every weekday.
#
# [*user*]
#   Which user to run as. This can be used if you wish to run a script without
#   invoking "sudo -u $user". Default is root, as per the standard cron job.
#
# [*mailto*]
#   Specifically set where the cron should attempt to email output to.
#   Example would be a user or an email address, or use an empty string to
#   suppress mailing any output.
#
# [*path*]
#   Set an environment path to load for the cron job
#   eg '/usr/bin:/usr/local/bin'
#
# [*ensure*]
#   Ensure the file is created. Set to 'absent' to remove the cron job if it is
#   no longer required.
#
define cron::crondotdee (
  $command,
  $hour,
  $minute,
  $day = '*',
  $month = '*',
  $weekday = '*',
  $user = 'root',
  $mailto = undef,
  $path = undef,
  $ensure = 'present',
) {
  file { "/etc/cron.d/${title}":
    ensure  => $ensure,
    content => template('cron/etc/cron.d/crondotdee.erb'),
    require => Class['cron'],
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }
}

