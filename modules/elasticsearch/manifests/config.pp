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
    ensure => present,
    source => 'puppet:///modules/elasticsearch/logging.yml',
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

  @nagios::nrpe_config { 'check_elasticsearch':
    source => 'puppet:///modules/elasticsearch/check_elasticsearch.cfg',
  }

  @@nagios::check { "check_elasticsearch-${cluster_name}_running_on_${::hostname}":
    check_command       => "check_nrpe!check_elasticsearch!${http_port}",
    service_description => 'elasticsearch not running',
    host_name           => $::fqdn,
  }

  @nagios::nrpe_config { 'check_elasticsearch_cluster_health':
    source => 'puppet:///modules/elasticsearch/check_elasticsearch_cluster_health.cfg',
  }

  @@nagios::check { "check_elasticsearch-${cluster_name}_cluster_health_running_on_${::hostname}":
    check_command       => "check_nrpe!check_elasticsearch_cluster_health!${http_port}",
    service_description => 'elasticsearch cluster is not healthy',
    host_name           => $::fqdn,
    document_url        => 'https://sites.google.com/a/digital.cabinet-office.gov.uk/wiki/projects-and-processes/gov-uk/ops-manual/nagios-alerts-documentation-actions',
  }

}
