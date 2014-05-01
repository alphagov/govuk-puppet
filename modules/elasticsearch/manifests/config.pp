# FIXME: make the file paths not depend on $cluster_name
class elasticsearch::config (
  $cluster_hosts,
  $cluster_name,
  $heap_size,
  $http_port,
  $mlock_all,
  $number_of_replicas,
  $number_of_shards,
  $refresh_interval,
  $transport_port,
  $minimum_master_nodes,
  $host,
) {
  $es_home = "/var/apps/elasticsearch-${cluster_name}"

  file { $es_home:
    ensure  => 'directory',
    recurse => true,
    purge   => true,
    force   => true,
  }

  file { "${es_home}/config":
    ensure => directory,
  }

  file { "${es_home}/config/elasticsearch.yml":
    ensure  => present,
    content => template('elasticsearch/elasticsearch.yml.erb'),
  }

  file { "${es_home}/config/logging.yml":
    ensure  => present,
    content => template('elasticsearch/logging.yml.erb'),
  }

  file { "${es_home}/bin":
    ensure => link,
    target => '/usr/share/elasticsearch/bin',
  }

  file { "${es_home}/lib":
    ensure => link,
    target => '/usr/share/elasticsearch/lib',
  }

  file { "${es_home}/logs":
    ensure => link,
    target => '/var/log/elasticsearch',
  }

  file { "${es_home}/plugins":
    ensure => link,
    target => '/usr/share/elasticsearch/plugins',
  }

  file { '/mnt/elasticsearch':
    ensure => directory,
    owner  => 'elasticsearch',
  }

  file { "${es_home}/data":
    ensure => link,
    target => '/mnt/elasticsearch',
  }

  file { "/etc/init/elasticsearch-${cluster_name}.conf":
    content => template('elasticsearch/upstart.conf.erb'),
  }

  @icinga::nrpe_config { 'check_elasticsearch_cluster_health':
    source => 'puppet:///modules/elasticsearch/check_elasticsearch_cluster_health.cfg',
  }

  # Check against the total number of hosts, not the minimum, else the alert
  # won't fire correctly
  $host_count = size($cluster_hosts)
  @@icinga::check { "check_elasticsearch-${cluster_name}_cluster_health_running_on_${::hostname}":
    check_command       => "check_nrpe!check_elasticsearch_cluster_health!${host_count}",
    service_description => 'elasticsearch cluster is not healthy',
    host_name           => $::fqdn,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#elasticsearch-cluster-health',
  }

}
