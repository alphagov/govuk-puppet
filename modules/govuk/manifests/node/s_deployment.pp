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
    certtype => 'wildcard_alphagov_mgmt',
  }

  nginx::config::site { 'jenkins':
    content => template('govuk/node/s_deployment/jenkins.conf.erb'),
    require => Nginx::Config::Ssl['jenkins'],
  }

  nginx::config::site { 'monitoring-proxy':
    content => template('govuk/node/s_deployment/monitoring-proxy.conf.erb'),
  }

  File {
    owner => jenkins,
    group => jenkins,
  }

  $github_ca_cert_content = extlookup('github_ca_cert')

  file {
    '/home/jenkins/govuk':
      ensure  => directory;
    '/home/jenkins/govuk/cert':
      ensure  => directory;
    '/home/jenkins/govuk/cert/github.gds.pem':
      ensure  => present,
      content => $github_ca_cert_content;
  }
}
