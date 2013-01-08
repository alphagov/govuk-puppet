class govuk::node::s_deployment inherits govuk::node::s_base {
  include jenkins::master
  include govuk::vpnc

  # Close connection if vhost not known
  nginx::config::vhost::default { 'default':
    status         => '444',
    status_message => '',
  }

  nginx::config::site { 'monitoring-proxy':
    content => template('jenkins/monitoring-proxy.conf.erb'),
  }
}
