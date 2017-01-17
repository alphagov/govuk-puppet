# == Class: Govuk::Node::S_jenkins
#
# Sets up the deployment Jenkins standalone instance
#
# === Parameters:
#
# [*github_client_id*]
#   The Github client ID is used as the user to authenticate against Github.
#
# [*github_client_secret*]
#   The Github client secret is used to authenticate against Github.
#
# [*jenkins_api_token*]
#   The API token for Jenkins user.
#
# [*environment_variables*]
#   A hash of environment variables that should be set for all Jenkins jobs.
#
class govuk::node::s_jenkins (
  $github_client_id = undef,
  $github_client_secret = undef,
  $jenkins_api_token = undef,
  $environment_variables = {},
) inherits govuk::node::s_base {
  include nginx
  include govuk_ghe_vpn
  include govuk_rbenv::all
  include ::govuk_testing_tools

  class { 'govuk_jenkins':
    github_client_id      => $github_client_id,
    github_client_secret  => $github_client_secret,
    jenkins_api_token     => $jenkins_api_token,
    environment_variables => $environment_variables,
  }

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
