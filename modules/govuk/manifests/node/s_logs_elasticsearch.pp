# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_logs_elasticsearch inherits govuk::node::s_base {

  $es_heap_size = $::memtotalmb / 4 * 3

  include govuk_java::oracle7::jre

  class { 'govuk_java::set_defaults':
    jdk => 'oracle7',
    jre => 'oracle7',
  }

  include govuk::repository # Old version of ES.
  class { 'govuk_elasticsearch':
    cluster_hosts        => ['logs-elasticsearch-1.management:9300', 'logs-elasticsearch-2.management:9300', 'logs-elasticsearch-3.management:9300'],
    cluster_name         => 'logging',
    heap_size            => "${es_heap_size}m",
    number_of_replicas   => '1',
    minimum_master_nodes => '2',
    host                 => $::fqdn,
    log_index_type_count => {
      'logs-current' => ['syslog']
    },
    disable_gc_alerts    => true,
    require              => [
      Class['govuk_java::oracle7::jre'],
      Class['govuk_java::set_defaults'],
      Govuk::Mount['/mnt/elasticsearch']
    ],
  }

  elasticsearch_old::plugin { 'redis-river':
    install_from => 'https://github.com/downloads/leeadkins/elasticsearch-redis-river/elasticsearch-redis-river-0.0.4.zip',
  }

  elasticsearch_old::plugin { 'head':
    install_from => 'mobz/elasticsearch-head',
  }

  # Install a template for *ALL* indices on this elasticsearch node which sets
  # up some favourable settings for storing logging data. Of note:
  #
  # settings.store.compress.stored:
  #   compress logs on disk
  # mappings._default_._all.enabled:
  #   disable indexing of full documents
  # mappings._default_.properties.@fields.properties.clientip:
  #   an example of how to configure analyzers for a specific field
  #
  elasticsearch_old::template { 'wildcard':
    content => '
    {
      "template": "*",
      "order": 0,
      "settings": {
        "index.query.default_field": "@message",
        "index.store.compress.stored": "true",
        "index.number_of_shards": "5",
        "index.cache.field.type": "soft",
        "index.refresh_interval": "5s"
      },
      "mappings": {
        "_default_": {
          "_all": { "enabled": false },
          "properties": {
            "@fields": {
              "path": "full",
              "dynamic": true,
              "properties": {
                "clientip": {
                  "type": "ip"
                },
                "parameters": { "index": "not_analyzed", "type": "object" }
              },
              "type": "object"
            },
            "@message":     { "index": "analyzed", "type": "string" },
            "@source":      { "index": "not_analyzed", "type": "string" },
            "@source_host": { "index": "not_analyzed", "type": "string" },
            "@source_path": { "index": "not_analyzed", "type": "string" },
            "@tags":        { "index": "not_analyzed", "type": "string" },
            "@timestamp":   { "index": "not_analyzed", "type": "date" },
            "@type":        { "index": "not_analyzed", "type": "string" }
          }
        }
      }
    }'
  }

  # Collect all elasticsearch_old::river resources exported by the environment's
  # redis machines.
  Elasticsearch_old::River <<| tag == 'logging' |>>

  cron { 'elasticsearch-rotate-indices':
    ensure  => present,
    user    => 'nobody',
    hour    => '0',
    minute  => '1',
    #FIXME: 2014-01-12 - This should be 21 rather than 8 days - need to fix logstasher gem first
    command => '/usr/local/bin/es-rotate --delete-old --delete-maxage 8 --optimize-old --optimize-maxage 1 logs',
    require => Class['govuk_elasticsearch'],
  }

  @@icinga::check::graphite { "check_elasticsearch_syslog_input_${::hostname}":
    target    => "removeBelowValue(derivative(${::fqdn_underscore}.curl_json-elasticsearch.gauge-logs-current_syslog_count),0)",
    critical  => '0.000001:',
    warning   => '0.000001:',
    desc      => 'elasticsearch not receiving syslog from logstash',
    host_name => $::fqdn,
  }

  Govuk::Mount['/mnt/elasticsearch'] -> Class['govuk_elasticsearch']
}
