class govuk::node::s_management inherits govuk::node::s_management_base {
  include nginx
  include jenkins::master

  include apache::remove

  nginx::config::vhost::default { 'default':
    # Close connection if vhost not known
    status         => '444',
    status_message => '',
    # Match vhost below for non-SNI clients.
    ssl_certtype   => 'ci_alphagov',
  }

  nginx::config::ssl { 'jenkins':
    certtype => 'ci_alphagov',
  }

  nginx::config::site { 'jenkins':
    content => template('govuk/node/s_management/jenkins.conf.erb'),
    require => Nginx::Config::Ssl['jenkins'],
  }
}
