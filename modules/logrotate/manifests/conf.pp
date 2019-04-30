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
# [*copytruncate*]
#   Boolean, sets the copytruncate option in logrotate
#
# [*create*]
#   A string to pass to the create option in logrotate
#
# [*delaycompress*]
#   Boolean, sets the delaycompress option in logrotate
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
# [*sharedscripts*]
#   Boolean, sets the sharedscripts option in logrotate
#
# [*maxsize*]
#   Specify the maximum size of a log file before it must get rotated.
#
define logrotate::conf (
  $matches,
  $days_to_keep = hiera('logrotate::conf::days_to_keep', '31'),
  $ensure = 'present',
  $user = undef,
  $group = undef,
  $copytruncate = true,
  $create = undef,
  $delaycompress = false,
  $prerotate = undef,
  $postrotate = undef,
  $rotate_if_empty = false,
  $sharedscripts = false,
  $maxsize = undef,
) {

  file { "/etc/logrotate.d/${title}":
    ensure  => $ensure,
    content => template('logrotate/logrotate.conf.erb'),
    require => Package['logrotate'],
  }

}
