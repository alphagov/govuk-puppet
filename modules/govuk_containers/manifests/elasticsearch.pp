# == Class: govuk_containers::elasticsearch
#
# Install and run a dockerised Elasticsearch server
#
# === Parameters
#
# [*image_name*]
#   Docker image name to use for the container.
#
# [*image_version*]
#   The docker image version to use.
#
# [*elasticsearch_port*]
#   The port (outside the container) to use for elasticsearch.
#
class govuk_containers::elasticsearch(
  $image_name = 'elastic/elasticsearch',
  $image_version = '5.6.15',
  $elasticsearch_port = '9205',
) {

  file { '/etc/elasticsearch-docker.yml':
    ensure  => present,
    content => template('govuk_containers/elasticsearch.yml'),
  }

  ::docker::image { $image_name:
    ensure    => 'present',
    require   => Class['govuk_docker'],
    image_tag => $image_version,
  }

  ::docker::run { 'elasticsearch':
    ports   => ["${elasticsearch_port}:9200"],
    image   => "${image_name}:${image_version}",
    require => [Docker::Image[$image_name], File['/etc/elasticsearch-docker.yml']],
    env     => ['"ES_JAVA_OPTS=-Xms512m -Xmx512m"', 'discovery.type=single-node', 'xpack.security.enabled=false'],
    volumes => ['esdata5:/usr/share/elasticsearch/data', 'dataimport:/usr/share/elasticsearch/import', '/etc/elasticsearch-docker.yml:/usr/share/elasticsearch/config/elasticsearch.yml'],
  }

  @@icinga::check { "check_elasticsearch_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!elasticsearch',
    service_description => 'dockerised elasticsearch running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }
}
