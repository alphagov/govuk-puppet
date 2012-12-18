class govuk::node::management_server_slave inherits govuk::node::base {
  include govuk::node::management_server
  include jenkins::slave

  ssh_authorized_key { 'management_server_master':
    type => rsa,
    key  => extlookup('jenkins_key', ''),
    user => 'jenkins'
  }
}
