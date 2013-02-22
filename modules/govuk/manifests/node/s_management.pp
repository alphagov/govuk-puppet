class govuk::node::s_management inherits govuk::node::s_base {
  include govuk::node::s_management_base
  include nginx
  include jenkins::master
  include govuk::openconnect

  include apache::remove

  # Close connection if vhost not known
  nginx::config::vhost::default { 'default':
    status         => '444',
    status_message => '',
  }

  nginx::config::site { 'jenkins':
    content => template('govuk/node/s_management/jenkins.conf.erb'),
  }

  host { 'github.gds':
    ip      => '192.168.9.110',
    comment => 'Ignore VPN DNS and set static host for GHE',
  }
}
