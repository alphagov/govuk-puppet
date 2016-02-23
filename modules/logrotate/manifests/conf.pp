# == Define: logrotate::conf
#
# Creates a logrotate config file on disk
#
# === Parameters
#
# [*matches*]
#   A glob of files that the logrotate should match
#
# [*days_to_keep*]
#   The number of days that logs should be retained
#
# [*ensure*]
#   Whether the logrotate config should be created
#
# [*user*]
#   If provided with `$group`, the user to pass to `su`
#
# [*group*]
#   If provided with `$user`, the group to pass to `su`
#
# [*prerotate*]
#   A script for logrotate to run before rotating
#
# [*postrotate*]
#   A script for logrotate to run after rotating
#
define logrotate::conf (
  $matches,
  $days_to_keep = '31',
  $ensure = 'present',
  $user = undef,
  $group = undef,
  $prerotate = undef,
  $postrotate = undef,
) {

  file { "/etc/logrotate.d/${title}":
    ensure  => $ensure,
    content => template('logrotate/logrotate.conf.erb'),
    require => Package['logrotate'],
  }

}
