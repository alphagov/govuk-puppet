# == Class: govuk::node::s_mongo_api
#
# mongo-api node
#
class govuk::node::s_mongo_api inherits govuk::node::s_base {
  include mongodb::server
  include govuk_env_sync

  collectd::plugin::tcpconn { 'mongo_api':
    incoming => 27017,
    outgoing => 27017,
  }
}
