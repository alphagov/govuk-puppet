class govuk::node::s_exception_handler inherits govuk::node::s_base {
  # Remove mongodb20 package before attempting to install the mongodb package
  # Otherwise they will conflict.
  # This can be removed once it's run everywhere.
  package {'mongodb20-10gen':
    ensure => purged,
    before => Anchor['mongodb::begin'],
  }

  include mongodb::server
  include mongodb::backup

  $mongo_hosts = ['localhost']

  class { 'mongodb::configure_replica_set':
    members => $mongo_hosts
  }
  include nginx
  include govuk::apps::errbit
}
