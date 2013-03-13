class govuk::node::s_deployment inherits govuk::node::s_base {
  include nginx
  include jenkins::master
  include govuk::ghe_vpn

  # Close connection if vhost not known
  nginx::config::vhost::default { 'default':
    status         => '444',
    status_message => '',
  }

  nginx::config::ssl { 'jenkins':
    certtype => 'wildcard_alphagov',
  }

  nginx::config::site { 'jenkins':
    content => template('govuk/node/s_deployment/jenkins.conf.erb'),
    require => Nginx::Config::Ssl['jenkins'],
  }

  nginx::config::site { 'monitoring-proxy':
    content => template('govuk/node/s_deployment/monitoring-proxy.conf.erb'),
  }
}
