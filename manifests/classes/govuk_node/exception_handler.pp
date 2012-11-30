class govuk_node::exception_handler inherits govuk_node::base {
  include mongodb::server

  $mongo_hosts = ['localhost']

  class { 'mongodb::configure_replica_set':
    members => $mongo_hosts
  }
  class { 'mongodb::backup':
    members => $mongo_hosts
  }
  include nginx
  include govuk::apps::errbit
}
