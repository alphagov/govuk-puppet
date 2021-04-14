# == Class: govuk::node::s_performance_mongo
#
# performance-mongo node - mongo cluster for performance platform
#
class govuk::node::s_performance_mongo inherits govuk::node::s_base {
  include mongodb::server
  include mongodb::backup

  collectd::plugin::tcpconn { 'mongo':
    incoming => 27017,
    outgoing => 27017,
  }

}
