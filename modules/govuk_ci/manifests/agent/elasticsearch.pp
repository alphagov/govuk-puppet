# == Class: govuk_ci::agent::elasticsearch
#
# Installs and configures elasticsearch
#
class govuk_ci::agent::elasticsearch {
  include ::govuk_docker

  class { '::govuk_containers::elasticsearch':
    elasticsearch_port => '9200',
  }
}
