# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class collectd::plugin::elasticsearch(
  $es_port,
  $log_index_type_count = {},
) {
  include collectd::plugin::curl_json

  @collectd::plugin { 'elasticsearch':
    content => template('collectd/etc/collectd/conf.d/elasticsearch.conf.erb'),
    require => Class['collectd::plugin::curl_json'],
  }
}
