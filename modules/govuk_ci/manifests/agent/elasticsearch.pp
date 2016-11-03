# == Class: govuk_ci::agent::elasticsearch
#
# Installs and configures elasticsearch
#
# === Parameters
#
# [*heap_size*]
#   Sets the heap size of the jvm
#
# [*elasticsearch_version*]
#   The version of elasticsearch to install
#
class govuk_ci::agent::elasticsearch(
  $heap_size = '64m',
  $elasticsearch_version = '1.7.5',
) {
  include ::govuk_java::openjdk7::jre
  include ::govuk_java::openjdk7::jdk

  class { 'govuk_java::set_defaults':
    jdk => 'openjdk7',
    jre => 'openjdk7',
  }

  class { 'govuk_elasticsearch':
    cluster_hosts          => ["${::hostname}:9300"],
    cluster_name           => 'elasticsearch',
    heap_size              => $heap_size,
    host                   => $::fqdn,
    open_firewall_from_all => true,
    version                => $elasticsearch_version,
    require                => [Class['govuk_java::openjdk7::jre'],Class['govuk_java::set_defaults']],
  }

}
