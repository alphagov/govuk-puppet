# == Class: govuk_ci::agent::elasticsearch
#
# Installs and configures elasticsearch
#
class govuk_ci::agent::elasticsearch {
  include ::govuk_docker
  include ::govuk_containers::elasticsearch::primary
}
