class govuk::node::s_mongo inherits govuk::node::s_base {
  include mongodb::server
  include mongodb::backup

  class { 'mongodb::configure_replica_set':
    members => [
      'backend-1.mongo',
      'backend-2.mongo',
      'backend-3.mongo',
    ]
  }

  collectd::plugin::tcpconn { 'mongo':
    incoming => 27017,
    outgoing => 27017,
  }

  govuk::mount { '/var/lib/automongodbbackup':
    mountoptions => 'defaults',
    disk         => '/dev/mapper/backup-mongodb',
  }

  govuk::mount { '/var/lib/mongodb':
    mountoptions => 'defaults',
    disk         => '/dev/mapper/mongodb-data',
  }
}
