# == Class: govuk_elasticsearch
#
# GOV.UK specific class to configure what is currently an in-house ES
# module, but will in future be elasticsearch/puppet-elasticsearch.
#
# === Parameters
#
# Lots missing!
#
# [*version*]
#   The version of elasticsearch to install.  This must specify an exact
#   version (eg 1.4.2)
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
#
# [*backup_enabled*]
#   Boolean. Whether backup class will be included.
#
# [*cors_enabled*]
#   Boolean. Whether cross-origin-resource-sharing is enabled.  i.e. whether a
#   browser on another origin can execute requests against Elasticsearch.
#
# [*cors_accept_headers*]
#   Comma separated list of request headers that are accepted for CORS requests.
#
# [*cors_allow_origin]
#   Origins to allow if cors_enabled is set to true. The value is intepreted as
#   a regular expression if it starts with a leading '/'.
#
# [*aws_cluster_name]
#   If in AWS, specify the tag called "cluster_name" to discovery other hosts
#   that should be part of the cluster.
#
# [*aws_region*]
#   If in AWS, the region in which the cluster lives.
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
  $open_firewall_from_all = false,
  $backup_enabled = false,
  $cors_enabled = false,
  $cors_allow_headers = 'X-Requested-With, Content-Type, Content-Length, If-Modified-Since',
  $cors_allow_origin = 'http://app.quepid.com',
  $aws_cluster_name = undef,
  $aws_region = 'eu-west-1',
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

  if $::aws_migration {
    $discovery_config = {
      'type'  => 'ec2',
      'zen'   => {
        'minimum_master_nodes' => $minimum_master_nodes,
      },
      'ec2'   => {
        'tag.cluster_name' => $aws_cluster_name,
      },
    }
  } else {
    $discovery_config = {
      'zen' => {
        'minimum_master_nodes' => $minimum_master_nodes,
        'ping'                 => {
          'multicast.enabled' => false,
          'unicast.hosts'     => $cluster_hosts,
        },
      },
    }
  }

  $instance_config = {
    'cluster.name'             => $cluster_name,
    'index.number_of_replicas' => $number_of_replicas,
    'index.number_of_shards'   => $number_of_shards,
    'index.refresh_interval'   => $refresh_interval,
    'transport.tcp.port'       => $transport_port,
    'network.publish_host'     => $::fqdn,
    'node.name'                => $::fqdn,
    'http.port'                => $http_port,
    'http.cors.enabled'        => $cors_enabled,
    'http.cors.allow-headers'  => $cors_allow_headers,
    'http.cors.allow-origin'   => $cors_allow_origin,
    'discovery'                => $discovery_config,
    'cloud.aws.region'         => $aws_region,
  }
  if versioncmp($version, '1.4.3') >= 0 {
    # 1.4.3 introduced this setting and set it to false by default
    # http://www.elastic.co/guide/en/elasticsearch/reference/1.x/modules-scripting.html
    $instance_config_real = merge($instance_config,{
      'action.destructive_requires_name' => true,
      'script.groovy.sandbox.enabled' => true
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

  Class['elasticsearch'] -> Elasticsearch::Instance[$::fqdn] -> Anchor['govuk_elasticsearch::end']

  class { 'govuk_elasticsearch::monitoring':
    host_count           => size($cluster_hosts),
    cluster_name         => $cluster_name,
    http_port            => $http_port,
    log_index_type_count => $log_index_type_count,
    disable_gc_alerts    => $disable_gc_alerts,
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

  if ! $::aws_migration {
    govuk_elasticsearch::firewall_transport_rule { $cluster_hosts: }
  } else {
    # Since UFW is setup as deny by default we need to open the up the firewall
    # from everyone, and firewalling is handled by Security Groups
    @ufw::allow { "allow-elasticsearch-transport-${transport_port}":
      port => $transport_port,
    }
  }

  include govuk_elasticsearch::estools
  include govuk_elasticsearch::plugins

  if $backup_enabled {
    include govuk_elasticsearch::backup
  }
  anchor { 'govuk_elasticsearch::end': }
}
