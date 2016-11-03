# == Class: govuk_ci::agent::mongodb
#
# Installs and configures mongodb-server
#
class govuk_ci::agent::mongodb {

  include ::mongodb::server

}