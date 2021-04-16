# == Class: govuk::node::s_mongo
#
# mongo node
#
class govuk::node::s_mongo inherits govuk::node::s_base {
  include mongodb::server
  include govuk_env_sync

  collectd::plugin::tcpconn { 'mongo':
    incoming => 27017,
    outgoing => 27017,
  }
}
