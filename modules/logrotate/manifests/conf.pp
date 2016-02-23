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
# [*rotate_if_empty*]
#   Boolean, tells logrotate to rotate the file even if it is empty
#
define logrotate::conf (
  $matches,
  $days_to_keep = '31',
  $ensure = 'present',
  $user = undef,
  $group = undef,
  $prerotate = undef,
  $postrotate = undef,
  $rotate_if_empty = false,
) {

  file { "/etc/logrotate.d/${title}":
    ensure  => $ensure,
    content => template('logrotate/logrotate.conf.erb'),
    require => Package['logrotate'],
  }

}
