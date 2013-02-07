class collectd::plugin::nginx(
  $status_url
) {
  @file { '/etc/collectd/conf.d/nginx.conf':
    ensure  => present,
    content => template('collectd/etc/collectd/conf.d/nginx.conf.erb'),
    tag     => 'collectd::plugin',
    notify  => Class['collectd::service'],
  }
}
