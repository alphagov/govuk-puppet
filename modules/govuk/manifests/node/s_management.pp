class govuk::node::s_management inherits govuk::node::s_base {
  include govuk::node::s_management_base
  include nginx
  include jenkins::master
  include govuk::ghe_vpn

  include apache::remove

  # Close connection if vhost not known
  nginx::config::vhost::default { 'default':
    status         => '444',
    status_message => '',
  }

  nginx::config::site { 'jenkins':
    content => template('govuk/node/s_management/jenkins.conf.erb'),
  }
}
