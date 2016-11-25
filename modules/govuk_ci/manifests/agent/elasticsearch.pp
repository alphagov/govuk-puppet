# == Class: govuk_ci::agent::elasticsearch
#
# Installs and configures elasticsearch
#
class govuk_ci::agent::elasticsearch {
  include ::govuk_java::openjdk7::jre
  include ::govuk_java::openjdk7::jdk

  class { 'govuk_java::set_defaults':
    jdk => 'openjdk7',
    jre => 'openjdk7',
  }

  class { 'govuk_elasticsearch':
    cluster_hosts => ["${::hostname}:9300"],
    cluster_name  => 'elasticsearch',
    host          => $::fqdn,
    require       => [Class['govuk_java::openjdk7::jre'],Class['govuk_java::set_defaults']],
  }

}
