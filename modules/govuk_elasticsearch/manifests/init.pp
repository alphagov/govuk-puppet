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
# [*log_slow_queries*]
#   Boolean. Whether to enable Elasticsearch logs of slow search queries.
#   Default: false
#
# [*slow_query_log_level*]
#   The log level for logging Elasticsearch slow queries. See https://www.elastic.co/guide/en/elasticsearch/reference/2.4/index-modules-slowlog.html
#   for more information on log levels. Only used if slow query logging is
#   enabled using the log_slow_queries parameter.
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
  $log_slow_queries = false,
  $slow_query_log_level = 'warn',
  $repo_path = undef,
) {

  validate_re($version, '^\d+\.\d+\.\d+$', 'govuk_elasticsearch::version must be in the form x.y.z')
  include augeas
  validate_bool($manage_repo)


  if versioncmp($version, '5') >= 0 {
    $abbreviated_version = '5.x'
  } else {
    fail 'Unsupported version of elasticsearch'
  }

  anchor { 'govuk_elasticsearch::begin': }

  $http_port = '9200'
  $transport_port = '9300'

  if $manage_repo {
    class { 'govuk_elasticsearch::repo':
      repo_version => $abbreviated_version,
    }
  }

  class { 'elasticsearch':
    ensure  => 'absent',
    version => $version,
  }

  File <| title == "${elasticsearch::configdir}/${::fqdn}/scripts" |> {
    ensure => 'absent',
    force  => true,
  }

  class { 'govuk_elasticsearch::monitoring':
    host_count           => size($cluster_hosts),
    cluster_name         => $cluster_name,
    http_port            => $http_port,
    log_index_type_count => $log_index_type_count,
    disable_gc_alerts    => $disable_gc_alerts,
  }

  include govuk_unattended_reboot::elasticsearch

  include govuk_elasticsearch::estools

  if $backup_enabled {
    include govuk_elasticsearch::backup
  }
  anchor { 'govuk_elasticsearch::end': }
}
