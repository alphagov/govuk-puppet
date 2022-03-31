# == Class: Govuk::Node::S_jenkins
#
# Sets up the deployment Jenkins standalone instance
#
# === Parameters:
#
# [*github_client_id*]
#   The Github client ID is used as the user to authenticate against Github.
#
# [*github_client_secret_encrypted*]
#   The encrypted Github client secret is used to authenticate against Github.
#
# [*jenkins_api_token*]
#   The API token for Jenkins user.
#
# [*environment_variables*]
#   A hash of environment variables that should be set for all Jenkins jobs.
#
class govuk::node::s_jenkins (
  $github_client_id = undef,
  $github_client_secret_encrypted = undef,
  $jenkins_api_token = undef,
  $environment_variables = {},
) inherits govuk::node::s_base {
  include govuk_chromedriver
  include nginx
  include govuk_postgresql::client
  include govuk_rbenv::all

  class { 'govuk_jenkins':
    github_client_id               => $github_client_id,
    github_client_secret_encrypted => $github_client_secret_encrypted,
    jenkins_api_token              => $jenkins_api_token,
    environment_variables          => $environment_variables,
  }

  Govuk_mount['/var/lib/jenkins'] -> Class['govuk_jenkins']

  class { 'govuk_jenkins::deploy_all_apps':
    require => Class['govuk_jenkins'],
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

  # Required for a job that issues Jenkins Crumbs
  ensure_packages(['jq'])

  # can't use the collectd plugin because the installation conflicts
  # with some other python packages on the agent
  class { '::govuk_docker':
    docker_users           => ['jenkins'],
    enable_collectd_plugin => false,
  }

  cron::crondotdee { 'docker_system_prune_dangling' :
    hour    => '*',
    minute  => 0,
    command => 'docker system prune -f --filter="until=1h"',
  }

  cron::crondotdee { 'docker_system_prune_all' :
    hour    => 4,
    minute  => 30,
    command => 'docker system prune -a -f --filter="until=48h"',
  }

  cron::crondotdee { 'docker_volume_prune' :
    hour    => '*',
    minute  => 5,
    command => 'docker volume prune -f',
  }
}
