class govuk_node::management_server_slave inherits govuk_node::base {
  include govuk_node::management_server
  include jenkins::slave

  ssh_authorized_key { 'management_server_master':
    type => rsa,
    key  => extlookup('jenkins_key', ''),
    user => 'jenkins'
  }
}
