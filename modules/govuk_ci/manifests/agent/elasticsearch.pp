# == Class: govuk_ci::agent::elasticsearch
#
# Installs and configures elasticsearch
#
class govuk_ci::agent::elasticsearch {
  include ::govuk_java::openjdk8::jre
  include ::govuk_java::openjdk8::jdk

  class { 'govuk_java::set_defaults':
    jdk => 'openjdk8',
    jre => 'openjdk8',
  }

  class { 'govuk_elasticsearch':
    cluster_hosts => ["${::hostname}:9300"],
    cluster_name  => 'elasticsearch',
    host          => $::fqdn,
    require       => [Class['govuk_java::openjdk8::jre'],Class['govuk_java::set_defaults']],
  }

}
