define collectd::plugin::raindrops(
  $port
) {
  include collectd::plugin::curl

  @collectd::plugin { "raindrops-${title}":
    content => template('collectd/etc/collectd/conf.d/raindrops.conf.erb'),
    require => Class['collectd::plugin::curl'],
  }
}
