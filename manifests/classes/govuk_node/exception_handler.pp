class govuk_node::exception_handler inherits govuk_node::base {
  include mongodb::server

  $mongo_hosts = ['localhost']

  @@backup::directory {"backup_mongodb_backups_$::hostname":
    directory => '/var/lib/automongodbbackup/',
    host_name => $::hostname,
    fq_dn     => $::fqdn,
  }

  class { 'mongodb::configure_replica_set':
    members => $mongo_hosts
  }
  class { 'mongodb::backup':
    members => $mongo_hosts
  }
  include govuk::apps::errbit
}
