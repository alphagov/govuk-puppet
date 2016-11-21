# == Class: govuk::node::s_ci_master
#
# Class to manage the continuous deployment job controller
#
class govuk::node::s_ci_master inherits govuk::node::s_base {
  include ::nginx
  include ::govuk_rbenv::all
  include ::govuk_ci::master

  nginx::config::ssl { 'jenkins':
    certtype => 'wildcard_publishing',
  }

  nginx::config::site { 'jenkins':
    content => template('govuk/node/s_ci_master/jenkins.conf.erb'),
    require => Nginx::Config::Ssl['jenkins'],
  }
}
