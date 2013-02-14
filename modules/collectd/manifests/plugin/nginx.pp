class collectd::plugin::nginx(
  $status_url
) {
  @collectd::plugin { 'nginx':
    content => template('collectd/etc/collectd/conf.d/nginx.conf.erb'),
  }
}
