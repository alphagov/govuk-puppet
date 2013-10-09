class govuk::node::s_router_backend inherits govuk::node::s_base {
  include mongodb::server
  class { 'mongodb::configure_replica_set':
    members => [
      'router-backend-1.router',
      'router-backend-2.router',
      'router-backend-3.router',
    ],
  }
}
