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
class govuk_ci::master (
  $github_client_id,
  $github_client_secret,
  $ghe_vpn_username,
  $ghe_vpn_password,
  $jenkins_api_token,
){

  include ::govuk_ci::credentials

  class { '::govuk_jenkins':
    github_client_id     => $github_client_id,
    github_client_secret => $github_client_secret,
    jenkins_api_token    => $jenkins_api_token,
  }

  class { 'govuk_ghe_vpn':
    username => $ghe_vpn_username,
    password => $ghe_vpn_password,
  }

  # Collect exported jobs
  Govuk_ci::Job <<| |>>

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

}
