class govuk::node::s_jenkins inherits govuk::node::s_base {
  include nginx
  include jenkins::master
  include govuk::ghe_vpn

  # alphagov/redirector needs this library to run smoke tests
  include ::perl::libwww

  # Close connection if vhost not known
  nginx::config::vhost::default { 'default':
    status         => '444',
    status_message => '',
  }

  nginx::config::ssl { 'jenkins':
    certtype => 'wildcard_alphagov_mgmt',
  }

  nginx::config::site { 'jenkins':
    content => template('govuk/node/s_jenkins/jenkins.conf.erb'),
    require => Nginx::Config::Ssl['jenkins'],
  }

  File {
    owner => jenkins,
    group => jenkins,
  }

  $github_ca_cert_content = hiera('github_ca_cert')

  file {
    '/home/jenkins/govuk':
      ensure  => directory;
    '/home/jenkins/govuk/cert':
      ensure  => directory;
    '/home/jenkins/govuk/cert/github.gds.pem':
      ensure  => present,
      content => $github_ca_cert_content;
  }

  # Deployment machine acting as a local DNS resolver
  @ufw::allow { 'allow-dns-from-all':
    port  => 53,
    proto => 'any',
  }

}
