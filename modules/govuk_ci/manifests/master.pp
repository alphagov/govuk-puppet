# == Class: govuk_ci::master
#
# Class to manage continuous deployment master
#
class govuk_ci::master {

  include ::govuk_ci::credentials
  include ::govuk_jenkins

}
