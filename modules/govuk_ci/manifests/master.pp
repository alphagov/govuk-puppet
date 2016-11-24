# Class govuk_ci::master
#
# === Parameters
#
# [*agent_user*]
#   The user Jenkins agent's will use to make api calls.
#   This user's invoked from jenkins jobs.
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
class govuk_ci::master (
  $agent_user = 'agent',
  $github_client_id,
  $github_client_secret,
  $ghe_vpn_username,
  $ghe_vpn_password,
  $jenkins_api_token,
  $pipeline_jobs = {},
){

  include ::govuk_ci::credentials

  govuk_jenkins::api_user { 'pingdom': }
  govuk_jenkins::api_user { 'github_build_trigger': }
  govuk_jenkins::api_user { 'deploy_jenkins': }

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
