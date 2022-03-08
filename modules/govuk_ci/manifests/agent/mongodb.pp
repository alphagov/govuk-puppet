# == Class: govuk_ci::agent::mongodb
#
# Installs and configures mongodb-server
#
class govuk_ci::agent::mongodb {
  # Docker instances of MongoDB versions that are installed in
  # parallel with the Ubuntu Trusty version
  include ::govuk_docker
  ::govuk_containers::ci_mongodb { 'ci-mongodb-3.6':
    version => '3.6',
    port    => 27036,
  }

  include ::mongodb::server
}
