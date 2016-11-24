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
# [*ghe_vpn_username*]
#   The username used to connect to the Github Enterprise VPN
#
# [*ghe_vpn_password*]
#   The password to authenticate against the Github Enterprise VPN
#
# [*agent_user*]
#   The user account used by jenkins agents authenticate with the jenkins master
#
class govuk_ci::master (
  $github_client_id,
  $github_client_secret,
  $ghe_vpn_username,
  $ghe_vpn_password,
  $jenkins_api_token,
  $pipeline_jobs = {},
  $agent_user = 'agent_user',
){

  include ::govuk_ci::credentials

  ::govuk_jenkins::api_user { $agent_user: }

  class { '::govuk_jenkins':
    github_client_id     => $github_client_id,
    github_client_secret => $github_client_secret,
    jenkins_api_token    => $jenkins_api_token,
  }

  class { 'govuk_ghe_vpn':
    username => $ghe_vpn_username,
    password => $ghe_vpn_password,
  }

  # Add govuk-puppet job
  govuk_ci::job { 'govuk-puppet': }

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

}
