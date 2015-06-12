# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_logs_elasticsearch inherits govuk::node::s_base {

  $es_heap_size = $::memtotalmb / 2

  include govuk_java::openjdk7::jre

  class { 'govuk_java::oracle7::jdk':
    ensure => absent,
  }

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
      Class['govuk_java::openjdk7::jre'],
      Govuk::Mount['/mnt/elasticsearch']
    ],
  }

  elasticsearch::plugin { 'mobz/elasticsearch-head':
    module_dir => 'head',
    instances  => $::fqdn,
  }

  elasticsearch::plugin { 'redis-river':
    module_dir => 'redis-river',
    url        => 'https://github.com/downloads/leeadkins/elasticsearch-redis-river/elasticsearch-redis-river-0.0.4.zip',
    instances  => $::fqdn,
  }

  # Install a template with some favourable settings for storing logging data.
  elasticsearch::template { 'wildcard':
    file    => 'puppet:///modules/govuk/node/s_logs_elasticsearch/wildcard-template.json',
    require => Class['govuk_elasticsearch'],
  }

  # Collect all govuk_elasticsearch::river resources exported by the environment's
  # redis machines.
  Govuk_elasticsearch::River <<| tag == 'logging' |>>

  file { '/usr/local/bin/es-rotate-passive-check':
    ensure  => present,
    mode    => '0755',
    content => template('govuk/usr/local/bin/es-rotate-passive-check.erb'),
  }

  @@icinga::passive_check { "check_es_rotate_${::hostname}":
    service_description => 'es-rotate',
    host_name           => $::fqdn,
    freshness_threshold => 25 * (60 * 60), # 25 hours
    require             => File['/usr/local/bin/es-rotate-passive-check'],
  }

  cron { 'elasticsearch-rotate-indices':
    ensure  => present,
    user    => 'nobody',
    hour    => '0',
    minute  => '1',
    command => '/usr/local/bin/es-rotate-passive-check',
    require => [
      Class['govuk_elasticsearch::estools'],
      File['/usr/local/bin/es-rotate-passive-check'],
    ]
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
