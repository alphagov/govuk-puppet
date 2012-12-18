class govuk::node::deployment_server inherits govuk::node::base {
  include jenkins::master

  # Close connection if vhost not known
  nginx::config::vhost::default { 'default':
    status         => '444',
    status_message => '',
  }

  nginx::config::site { 'monitoring-proxy':
    content => template('jenkins/monitoring-proxy.conf.erb'),
  }
}
