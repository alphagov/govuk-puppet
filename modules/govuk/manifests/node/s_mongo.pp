# == Class: govuk::node::s_mongo
#
# mongo node
#
class govuk::node::s_mongo inherits govuk::node::s_base {
  include mongodb::server

  collectd::plugin::tcpconn { 'mongo':
    incoming => 27017,
    outgoing => 27017,
  }

  if ! $::aws_migration {
    Govuk_mount['/var/lib/mongodb'] -> Class['mongodb::server']
    Govuk_mount['/var/lib/automongodbbackup'] -> Class['mongodb::backup']
    Govuk_mount['/var/lib/s3backup'] -> Class['mongodb::backup']
  }

}
