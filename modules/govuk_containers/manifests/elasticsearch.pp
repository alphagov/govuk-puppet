# == Resource: govuk_containers::elasticsearch
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
define govuk_containers::elasticsearch(
  $image_name = 'elastic/elasticsearch',
  $image_version = '5.6.15',
  $elasticsearch_port = '9200',
  $ensure = 'present',
) {

  file { "/etc/elasticsearch-docker-${image_version}.yml":
    ensure  => $ensure,
    content => template('govuk_containers/elasticsearch.yml'),
  }

  ::docker::image { "${image_name}:${image_version}":
    ensure    => $ensure,
    require   => Class['govuk_docker'],
    image     => $image_name,
    image_tag => $image_version,
  }

  ::docker::run { "${image_name}:${image_version}":
    ensure  => $ensure,
    ports   => ["${elasticsearch_port}:9200"],
    image   => "${image_name}:${image_version}",
    require => [Docker::Image["${image_name}:${image_version}"], File["/etc/elasticsearch-docker-${image_version}.yml"]],
    env     => ['"ES_JAVA_OPTS=-Xms512m -Xmx512m"', 'discovery.type=single-node', 'xpack.security.enabled=false'],
    volumes => ['/usr/share/elasticsearch/data', '/usr/share/elasticsearch/import', "/etc/elasticsearch-docker-${image_version}.yml:/usr/share/elasticsearch/config/elasticsearch.yml"],
  }

  @icinga::nrpe_config { "check_dockerised_elasticsearch_${image_version}_responding":
    ensure => $ensure,
    source => 'puppet:///modules/govuk_containers/nrpe_check_dockerised_elasticsearch_responding.cfg',
  }

  @@icinga::check { "check_dockerised_elasticsearch_${image_version}_responding_${::hostname}":
    ensure              => $ensure,
    check_command       => "check_nrpe!check_dockerised_elasticsearch_responding!${elasticsearch_port}",
    service_description => 'dockerised elasticsearch port not responding',
    host_name           => $::fqdn,
  }
}
