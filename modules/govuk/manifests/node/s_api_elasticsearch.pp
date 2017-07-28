# == Class: govuk::node::s_api_elasticsearch
#
# Machines for the elasticsearch cluster in the API vDC
#
class govuk::node::s_api_elasticsearch inherits govuk::node::s_base {
  include govuk_java::openjdk7::jre

  $es_heap_size = floor($::memorysize_mb / 2)

  if $::aws_migration {
    $aws_cluster_name = "elasticsearch-${::aws_stackname}"
  }

  class { 'govuk_elasticsearch::dump':
    require => Class['govuk_elasticsearch'], # required for elasticsearch user to exist
  }

  class { 'govuk_elasticsearch':
    cluster_hosts          => ['api-elasticsearch-1.api:9300', 'api-elasticsearch-2.api:9300', 'api-elasticsearch-3.api:9300'],
    cluster_name           => 'govuk-content',
    heap_size              => "${es_heap_size}m",
    number_of_replicas     => '1',
    host                   => $::fqdn,
    open_firewall_from_all => false,
    require                => Class['govuk_java::openjdk7::jre'],
    aws_cluster_name       => $aws_cluster_name,
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

    # FIXME: Remove these firewall rules by moving the need-api app from the backend
    # machines to the API machines. The MongoDB database will need to move too.
    # There are more firewall rules in govuk-provisioning that can also be removed.
    @ufw::allow { 'allow-elasticsearch-http-9200-from-backend-1':
      port    => 9200,
      from    => getparam(Govuk_host['backend-1'], 'ip'),
      require => Govuk_host['backend-1'],
    }
    @ufw::allow { 'allow-elasticsearch-http-9200-from-backend-2':
      port    => 9200,
      from    => getparam(Govuk_host['backend-2'], 'ip'),
      require => Govuk_host['backend-2'],
    }
    @ufw::allow { 'allow-elasticsearch-http-9200-from-backend-3':
      port    => 9200,
      from    => getparam(Govuk_host['backend-3'], 'ip'),
      require => Govuk_host['backend-3'],
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
