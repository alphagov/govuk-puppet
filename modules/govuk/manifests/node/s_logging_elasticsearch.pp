class govuk::node::s_logging_elasticsearch inherits govuk::node::s_base {

  $es_heap_size = $::memtotalmb / 4 * 3

  include java::oracle7::jre

  $tld = extlookup('internal_tld', 'production')

  class { 'elasticsearch':
    cluster_hosts      => ['logs-elasticsearch-1.management:9300', 'logs-elasticsearch-2.management:9300', 'logs-elasticsearch-3.management:9300'],
    cluster_name       => 'logging',
    heap_size          => "${es_heap_size}m",
    number_of_replicas => '0',
    host               => "${::fqdn}.${tld}",
    require            => Class['java::oracle7::jre'],
  }

  elasticsearch::plugin { 'redis-river':
    install_from => 'leeadkins/elasticsearch-redis-river/0.0.4',
  }

  elasticsearch::plugin { 'head':
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
  elasticsearch::template { 'wildcard':
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
                }
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

  # Collect all elasticsearch::river resources exported by the environment's
  # redis machines.
  Elasticsearch::River <<| tag == 'logging' |>>

  cron { 'elasticsearch-rotate-indices':
    ensure  => present,
    user    => 'nobody',
    hour    => '0',
    minute  => '1',
    command => '/usr/local/bin/es-rotate --delete-old --delete-maxage 31 logs',
    require => Class['elasticsearch'],
  }

}
