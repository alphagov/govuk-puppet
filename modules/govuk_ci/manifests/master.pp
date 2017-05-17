# == Class: govuk_ci::master
#
# Class to manage continuous deployment master
#
# === Parameters:
#
# [*github_client_id*]
#   The Github client ID is used as the user to authenticate against Github.
#
# [*github_client_secret*]
#   The Github client secret is used to authenticate against Github.
#
# [*environment_variables*]
#   A hash of environment variables that should be set for all Jenkins jobs.
#
class govuk_ci::master (
  $github_client_id,
  $github_client_secret,
  $jenkins_api_token,
  $pipeline_jobs = {},
  $environment_variables = {},
  $ci_agents = {},
  $credentials_id,
){

  validate_hash($ci_agents)
  validate_hash($pipeline_jobs)
  validate_hash($environment_variables)

  include ::govuk_ci::credentials
  include ::govuk_ci::limits
  include ::govuk_ci::vpn

  # After these users have been created, you'll have to retrieve the API token from the UI
  govuk_jenkins::api_user { 'jenkins_agent': }

  class { '::govuk_jenkins':
    github_client_id      => $github_client_id,
    github_client_secret  => $github_client_secret,
    jenkins_api_token     => $jenkins_api_token,
    environment_variables => $environment_variables,
  }

  # Manually add jobs that we do not want to included in the 'Deploy App' job
  govuk_ci::job { 'govuk-dns': }
  govuk_ci::job { 'govuk-dns-config':
    source => 'github-enterprise',
  }

  # Add pipeline jobs from applications hash in Hieradata
  create_resources(govuk_ci::job, $pipeline_jobs)

  ufw::allow {'jenkins-slave-to-jenkins-master-on-tcp':
    port  => '32768:65535',
    proto => 'tcp',
    ip    => 'any',
  }

  ufw::allow {'jenkins-slave-to-jenkins-master-on-udp':
    port  => '33848',
    proto => 'udp',
    ip    => 'any',
  }

  # Override sudoers.d resource (managed by sudo module) to enable Jenkins user to run sudo tests
  File<|title == '/etc/sudoers.d/'|> {
    mode => '0555',
  }

  create_resources('::govuk_jenkins::ssh_slave', $ci_agents, {
    'credentials_id' => $credentials_id,
  })

  cron::crondotdee { 'clean_up_pipeline_workspace':
    command => 'find /var/lib/jenkins/workspace/*@script -maxdepth 0 -type d -mtime +1 -exec rm -rf {} \;',
    hour    => 7,
    minute  => 45,
  }

  # Restart Jenkins nightly: using the govuk_jenkins::reload class means that Jenkins goes for long
  # periods without a restart, which seems to cause some issues with the service.
  cron::crondotdee { 'restart_jenkins_service':
    command => '/usr/sbin/service jenkins restart',
    hour    => 0,
    minute  => 0,
  }

}
