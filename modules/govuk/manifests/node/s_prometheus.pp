# == Class: govuk::node::s_prometheus
#
# Class to specify a machine as a prometheus server
#
class govuk::node::s_prometheus inherits govuk::node::s_base {

  include govuk::apps::prometheus
  include govuk_prometheus

}
