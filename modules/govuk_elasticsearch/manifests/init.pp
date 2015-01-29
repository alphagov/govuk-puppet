# == Class: govuk_elasticsearch
#
# GOV.UK specific class to configure what is currently an in-house ES
# module, but will in future be elasticsearch/puppet-elasticsearch.
#
# === Parameters
#
# Lots missing!
#
# [*use_mirror*]
#   Whether to use our own mirror of the Elasticsearch repo.
#   Default: true
#
class govuk_elasticsearch (
  $version = 'present',
  $cluster_hosts = ['localhost'],
  $cluster_name = 'elasticsearch',
  $heap_size = '512m',
  $number_of_shards = '5',
  $number_of_replicas = '1',
  $minimum_master_nodes = '1',
  $refresh_interval = '1s',
  $host = 'localhost',
  $log_index_type_count = {},
  $disable_gc_alerts = false,
  $use_mirror = true,
) {

  include augeas
  validate_bool($use_mirror)

  anchor { 'govuk_elasticsearch::begin': }

  $http_port = '9200'
  $transport_port = '9300'

  if $use_mirror {
    class { 'govuk_elasticsearch::repo': }
    $manage_repo = false
    $repo_version = undef
  } else {
    $manage_repo = true
    $repo_version = '0.90'
  }

  class { 'elasticsearch':
    version      => $version,
    manage_repo  => $manage_repo,
    repo_version => $repo_version,
    require      => Anchor['govuk_elasticsearch::begin'],
    before       => Anchor['govuk_elasticsearch::end'],
  }

  # FIXME: Remove this when we're no longer relying on the elasticsearch_old module
  service { "elasticsearch-${cluster_name}":
    ensure   => 'stopped',
    stop     => "service elasticsearch-${cluster_name} stop",
    provider => 'base',
    before   => Elasticsearch::Instance[$::fqdn],
  }

  # FIXME: Remove this when we're no longer relying on the elasticsearch_old module
  exec { "/bin/mv /var/apps/${cluster_name} /mnt/elasticsearch":
    creates => '/mnt/elasticsearch',
    before  => Service["elasticsearch-${cluster_name}"],
    onlyif  => "/usr/bin/test -d /var/apps/${cluster_name}"
  }

  elasticsearch::instance { $::fqdn:
    config  => {
      'cluster.name'           => $cluster_name,
      'number_of_replicas'     => $number_of_replicas,
      'number_of_shards'       => $number_of_shards,
      'heap_size'              => $heap_size,
      'index.refresh_interval' => $refresh_interval,
      'transport.tcp.port'     => $transport_port,
      'network.publish_host'   => $::fqdn,
      'node.name'              => $::fqdn,
      'http.port'              => $http_port,
      'discovery'              => {
        'zen' => {
          'minimum_master_nodes' => $minimum_master_nodes,
          'ping'                 => {
            'multicast.enabled' => false,
            'unicast.hosts'     => $cluster_hosts,
          },
        },
      },
    },
    datadir => '/mnt/elasticsearch',
  }

  Class['elasticsearch'] -> Elasticsearch::Instance[$::fqdn] -> Anchor['govuk_elasticsearch::end']

  class { 'govuk_elasticsearch::monitoring':
    host_count           => size($cluster_hosts),
    cluster_name         => $cluster_name,
    http_port            => $http_port,
    log_index_type_count => $log_index_type_count,
    disable_gc_alerts    => $disable_gc_alerts,
  }

  @ufw::allow { "allow-elasticsearch-http-${http_port}-from-all":
    port => $http_port,
  }

  @ufw::allow { "allow-elasticsearch-transport-${transport_port}-from-all":
    port => $transport_port;
  }

  include govuk_elasticsearch::estools

  anchor { 'govuk_elasticsearch::end': }
}
