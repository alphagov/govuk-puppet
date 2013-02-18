class collectd::plugin::elasticsearch(
  $es_port
) {
  include collectd::plugin::curl_json

  @collectd::plugin { 'elasticsearch':
    content => template('collectd/etc/collectd/conf.d/elasticsearch.conf.erb'),
    require => Class['collectd::plugin::curl_json'],
  }
}
