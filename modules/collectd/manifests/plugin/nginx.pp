# == Class: collectd::plugin::nginx
#
# Setup a collectd plugin to monitor Nginx.
#
# === Parameters
#
# [*status_url*]
#   A URL which provides the status of Nginx as a response
#
class collectd::plugin::nginx(
  $status_url
) {
  @collectd::plugin { 'nginx':
    content => template('collectd/etc/collectd/conf.d/nginx.conf.erb'),
  }
}
