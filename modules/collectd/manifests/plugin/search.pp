class collectd::plugin::search(
  $app_port
) {
  include collectd::plugin::curl_json

  @collectd::plugin { 'search':
    content => template('collectd/etc/collectd/conf.d/search.conf.erb'),
    require => Class['collectd::plugin::curl_json'],
  }
}
