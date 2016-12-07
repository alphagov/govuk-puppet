# == Class: govuk_ci::agent::docker
#
# Installs and configures Docker and Docker Compose
class govuk_ci::agent::docker {
  include ::docker
  include ::docker::compose
}
