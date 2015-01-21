# == Class: nginx::logging
#
# Nginx log centralisation and rotation.
#
class nginx::logging {
  include govuk_heka::nginx

  file { '/etc/logrotate.d/nginx':
    ensure => present,
    source => 'puppet:///modules/nginx/etc/logrotate.d/nginx',
  }
}
