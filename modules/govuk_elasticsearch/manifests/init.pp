# == Class: govuk_elasticsearch
#
# GOV.UK specific class to configure what is currently an in-house ES
# module, but will in future be elasticsearch/puppet-elasticsearch.
#
# === Parameters
#
# Lots missing!
# [*aws_access_key*]
#   The AWS access key IDfor the IAM user with access to the S3 bucket where
#   index snapshots will go
#
# [*aws_secret_key*]
#   The AWS secret access key for the IAM user with access to the S3 bucket where
#   index snapshots will go
#
# [*manage_repo*]
#   Whether to configure an apt source for our mirror of the elasticsearch
#   repo. Disable to install elasticsearch from a separately configured repo.
#   Default: true
#
# [*open_firewall_from_all*]
#   Whether to add a firewall allow rule allowing all access to port 9200 (the
#   main http port). Typically set to false to allow restricting access to
#   specific machines.
#   Default: true
#
# [*version*]
#   The version of elasticsearch to install.  This must specify an exact
#   version (eg 1.4.2)
#
class govuk_elasticsearch (
  $version,
  $cluster_hosts = ['localhost'],
  $cluster_name = 'elasticsearch',
  $heap_size = '512m',
  $number_of_shards = '3',
  $number_of_replicas = '1',
  $minimum_master_nodes = '2',
  $refresh_interval = '1s',
  $host = 'localhost',
  $log_index_type_count = {},
  $disable_gc_alerts = false,
  $manage_repo = true,
  $open_firewall_from_all = true,
  $snapshot_backups = {},
  $aws_access_key = '',
  $aws_secret_key = '',
) {

  validate_re($version, '^\d+\.\d+\.\d+$', 'govuk_elasticsearch::version must be in the form x.y.z')
  include augeas
  validate_bool($manage_repo)

  anchor { 'govuk_elasticsearch::begin': }

  $http_port = '9200'
  $transport_port = '9300'

  if $manage_repo {
    $repo_version = regsubst($version, '\.\d+$', '') # 1.4.2 becomes 1.4 etc.
    class { 'govuk_elasticsearch::repo':
      repo_version => $repo_version,
    }
  }

  class { 'elasticsearch':
    version     => $version,
    manage_repo => false,
    require     => Anchor['govuk_elasticsearch::begin'],
    before      => Anchor['govuk_elasticsearch::end'],
  }

  exec { 'disable-default-elasticsearch':
    onlyif      => '/usr/bin/test -f /etc/init.d/elasticsearch',
    command     => '/etc/init.d/elasticsearch stop && /bin/rm -f /etc/init.d/elasticsearch && /usr/sbin/update-rc.d elasticsearch remove',
    before      => Elasticsearch::Instance[$::fqdn],
    subscribe   => Package['elasticsearch'],
    refreshonly => true,
  }

  Package['elasticsearch'] ~> Exec['disable-default-elasticsearch']

  $instance_config = {
    'cluster.name'             => $cluster_name,
    'index.number_of_replicas' => $number_of_replicas,
    'index.number_of_shards'   => $number_of_shards,
    'index.refresh_interval'   => $refresh_interval,
    'transport.tcp.port'       => $transport_port,
    'network.publish_host'     => $::fqdn,
    'node.name'                => $::fqdn,
    'http.port'                => $http_port,
    'discovery'                => {
      'zen' => {
        'minimum_master_nodes' => 2,
        'ping'                 => {
          'multicast.enabled' => false,
          'unicast.hosts'     => $cluster_hosts,
        },
      },
    },
    'cloud'                    => {
      'aws' => {
        'access_key' => $aws_access_key,
        'secret_key' => $aws_secret_key,
      },
    },
  }
  if versioncmp($version, '1.4.3') >= 0 {
    # 1.4.3 introduced this setting and set it to false by default
    # http://www.elastic.co/guide/en/elasticsearch/reference/1.x/modules-scripting.html
    $instance_config_real = merge($instance_config,{
      'action.destructive_requires_name' => true,
      'script.groovy.sandbox.enabled' => true
    })
  } elsif versioncmp($version, '0.90.12') >= 0 {
      $instance_config_real = merge($instance_config,{
        'action.disable_delete_all_indices' => true
    })
  } else {
    $instance_config_real = $instance_config
  }

  elasticsearch::instance { $::fqdn:
    config        => $instance_config_real,
    datadir       => '/mnt/elasticsearch',
    init_defaults => {
      'ES_HEAP_SIZE' => $heap_size,
    },
  }

  exec { 'secure_es_yaml':
    command     => "chmod 0640 /etc/elasticsearch/${::fqdn}/elasticsearch.yml",
    subscribe   => Elasticsearch::Instance[$::fqdn],
    refreshonly => true,
  }

  Class['elasticsearch'] -> Elasticsearch::Instance[$::fqdn] -> Anchor['govuk_elasticsearch::end']

  class { 'govuk_elasticsearch::monitoring':
    host_count           => size($cluster_hosts),
    cluster_name         => $cluster_name,
    http_port            => $http_port,
    log_index_type_count => $log_index_type_count,
    disable_gc_alerts    => $disable_gc_alerts,
    legacy_elasticsearch => versioncmp($version, '1.0.0') < 0, # version 0.x has different stats URLs etc.
  }

  include govuk_unattended_reboot::elasticsearch

  if $open_firewall_from_all {
    @ufw::allow { "allow-elasticsearch-http-${http_port}-from-all":
      port => $http_port,
    }
  } else {
    exec { "remove-allow-elasticsearch-http-${http_port}-from-all":
      command => "ufw delete allow ${http_port}/tcp",
      onlyif  => "ufw status | grep -E '${http_port}/tcp\s+ALLOW\s+Anywhere'",
    }
  }

  govuk_elasticsearch::firewall_transport_rule { $cluster_hosts: }

  include govuk_elasticsearch::estools

  anchor { 'govuk_elasticsearch::end': }

  create_resources(govuk_elasticsearch::snapshot, $govuk_elasticsearch::snapshot_backups)

}
