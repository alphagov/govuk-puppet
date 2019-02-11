# == Class: govuk::node::s_rummager_elasticsearch
#
# Machines for the elasticsearch cluster in the API vDC
#
# === Parameters
#
# [*aws_subnet*]
#   IPv4 subnet which will allow AWS hosts to contact this host when in
#   Staging or Production
#   Default: null
#
class govuk::node::s_rummager_elasticsearch (
  $aws_subnet = null,
) inherits govuk::node::s_base {
  include govuk_java::openjdk7::jre
  include govuk_env_sync

  $es_heap_size = floor($::memorysize_mb / 2)

  if $::aws_migration {
    $aws_cluster_name = "rummager-elasticsearch-${::aws_stackname}"
  }

  class { 'govuk_elasticsearch::dump':
    require => Class['govuk_elasticsearch'], # required for elasticsearch user to exist
  }

  class { 'govuk_elasticsearch':
    cluster_hosts        => ['rummager-elasticsearch-1.api:9300', 'rummager-elasticsearch-2.api:9300', 'rummager-elasticsearch-3.api:9300'],
    cluster_name         => 'govuk-content',
    heap_size            => "${es_heap_size}m",
    number_of_replicas   => '1',
    host                 => $::fqdn,
    require              => Class['govuk_java::openjdk7::jre'],
    aws_cluster_name     => $aws_cluster_name,
    log_slow_queries     => true,
    slow_query_log_level => 'info',
  }

  unless $::aws_migration {
    @ufw::allow { 'allow-elasticsearch-http-9200-from-search-1':
      port    => 9200,
      from    => getparam(Govuk_host['search-1'], 'ip'),
      require => Govuk_host['search-1'],
    }
    @ufw::allow { 'allow-elasticsearch-http-9200-from-search-2':
      port    => 9200,
      from    => getparam(Govuk_host['search-2'], 'ip'),
      require => Govuk_host['search-2'],
    }
    @ufw::allow { 'allow-elasticsearch-http-9200-from-search-3':
      port    => 9200,
      from    => getparam(Govuk_host['search-3'], 'ip'),
      require => Govuk_host['search-3'],
    }

    @ufw::allow { 'allow-elasticsearch-http-9200-from-calculators-frontend-1':
      port    => 9200,
      from    => getparam(Govuk_host['calculators-frontend-1'], 'ip'),
      require => Govuk_host['calculators-frontend-1'],
    }
    @ufw::allow { 'allow-elasticsearch-http-9200-from-calculators-frontend-2':
      port    => 9200,
      from    => getparam(Govuk_host['calculators-frontend-2'], 'ip'),
      require => Govuk_host['calculators-frontend-2'],
    }
    @ufw::allow { 'allow-elasticsearch-http-9200-from-calculators-frontend-3':
      port    => 9200,
      from    => getparam(Govuk_host['calculators-frontend-3'], 'ip'),
      require => Govuk_host['calculators-frontend-3'],
    }
  }

  if (! $::aws_migration) {
    @ufw::allow { 'allow-elasticsearch-http-9200-from-aws':
      port => 9200,
      from => $aws_subnet,
    }
  }

  collectd::plugin::tcpconn { 'es-9200':
    incoming => 9200,
    outgoing => 9200,
  }
  collectd::plugin::tcpconn { 'es-9300':
    incoming => 9300,
    outgoing => 9300,
  }

  Govuk_mount['/mnt/elasticsearch'] -> Class['govuk_elasticsearch']
}
