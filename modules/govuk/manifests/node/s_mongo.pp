# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_mongo inherits govuk::node::s_base {
  include mongodb::server
  include mongodb::backup

  collectd::plugin::tcpconn { 'mongo':
    incoming => 27017,
    outgoing => 27017,
  }

  Govuk::Mount['/var/lib/mongodb'] -> Class['mongodb::server']
  Govuk::Mount['/var/lib/automongodbbackup'] -> Class['mongodb::backup']
}
