# == Class: govuk::node::s_ci_master
#
# Class to manage the continuous deployment job controller
#
class govuk::node::s_ci_master inherits govuk::node::s_base {
  include ::nginx
  include ::govuk_rbenv::all
  include ::govuk_ci::master

  # Close connection if vhost not known
  nginx::config::vhost::default { 'default':
    status         => '444',
    status_message => '',
  }

  nginx::config::ssl { 'jenkins':
    certtype => 'wildcard_publishing',
  }

  nginx::config::site { 'jenkins':
    content => template('govuk/node/s_jenkins/jenkins.conf.erb'),
    require => Nginx::Config::Ssl['jenkins'],
  }
}
