class govuk::node::s_exception_handler inherits govuk::node::s_base {
  include mongodb::server
  include mongodb::backup

  $mongo_hosts = ['localhost']

  class { 'mongodb::configure_replica_set':
    members => $mongo_hosts
  }
  include nginx
  include govuk::apps::errbit

  Govuk::Mount['/var/lib/mongodb'] -> Class['mongodb::server']
  Govuk::Mount['/var/lib/automongodbbackup'] -> Class['mongodb::backup']
}
