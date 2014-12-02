# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_jenkins inherits govuk::node::s_base {
  include nginx
  include govuk_jenkins
  include govuk::ghe_vpn
  include govuk_rbenv::all

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

  # Deployment machine acting as a local DNS resolver
  @ufw::allow { 'allow-dns-from-all':
    port  => 53,
    proto => 'any',
  }

}
