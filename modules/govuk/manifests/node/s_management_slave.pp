class govuk::node::s_management_slave inherits govuk::node::s_base {
  include govuk::node::s_management
  include jenkins::slave
  include govuk::openconnect

  ssh_authorized_key { 'management_server_master':
    type => rsa,
    key  => extlookup('jenkins_key', 'NO_KEY_IN_EXTDATA'),
    user => 'jenkins'
  }
}
