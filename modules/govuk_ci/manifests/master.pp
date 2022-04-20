# == Class: govuk_ci::master
#
# Class to manage continuous deployment master
#
# === Parameters:
#
# [*pipeline_jobs*]
#   Hash of applications to create jobs for
#
# [*job_builder_jobs*]
#   Array of jobs created with the Job Builder plugin
#
# [*github_client_id*]
#   The Github client ID is used as the user to authenticate against Github.
#
# [*github_client_secret_encrypted*]
#   The encrypted Github client secret is used to authenticate against Github.
#
# [*environment_variables*]
#   A hash of environment variables that should be set for all Jenkins jobs.
#
class govuk_ci::master (
  $github_client_id,
  $github_client_secret_encrypted,
  $jenkins_api_token,
  $pipeline_jobs = {},
  $job_builder_jobs = [],
  $environment_variables = {},
  $ci_agents = {},
  $credentials_id,
){

  validate_hash($ci_agents)
  validate_hash($pipeline_jobs)
  validate_hash($environment_variables)

  include ::govuk_ci::credentials
  include ::govuk_ci::limits

  # After these users have been created, you'll have to retrieve the API token from the UI
#  govuk_jenkins::api_user { 'jenkins_agent': }

  class { '::govuk_jenkins':
    github_client_id               => $github_client_id,
    github_client_secret_encrypted => $github_client_secret_encrypted,
    jenkins_api_token              => $jenkins_api_token,
    environment_variables          => $environment_variables,
  }

  # Manually add jobs that we do not want to included in the 'Deploy App' job
  govuk_ci::job { 'govuk-dns': }
  govuk_ci::job { 'govuk-dns-config': }
  $manually_added_jobs = ['govuk-dns', 'govuk-dns-config'] # keep in sync with above

  # Add pipeline jobs from applications hash in Hieradata
  create_resources(govuk_ci::job, $pipeline_jobs)
  # Manually delete all jobs which aren't in the hash
  file { '/usr/local/bin/remove_old_jenkins_jobs':
    ensure  => present,
    mode    => '0755',
    content => template('govuk_ci/usr/local/bin/remove_old_jenkins_jobs.sh.erb'),
  }
  exec { 'single run of remove_old_jenkins_jobs after adding pipeline jobs':
    command => '/usr/local/bin/remove_old_jenkins_jobs',
  }

  # Only add this configuration for CI master Jenkins instances
  file { '/var/lib/jenkins/github-plugin-configuration.xml':
    ensure => file,
    owner  => 'jenkins',
    group  => 'jenkins',
    source => 'puppet:///modules/govuk_ci/github-plugin-configuration.xml',
    notify => Class['Govuk_jenkins::Reload'],
  }

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

  # Required for a job that issues Jenkins Crumbs
  ensure_packages(['jq'])

  file { '/var/lib/jenkins/.ssh/known_host':
    ensure => present,
    owner  => 'jenkins',
    group  => 'jenkins',
    mode   => '0644',
  }

}
