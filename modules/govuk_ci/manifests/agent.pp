# == Class: govuk_ci::agent
#
# Class to manage continuous deployment agents
#
class govuk_ci::agent {

  include ::govuk_ci::agent::redis

}