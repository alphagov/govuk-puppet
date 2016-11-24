# Class govuk_ci::agent::swarm
#
# Joins a jenkins agent machine to a jenkins master/cluster by downloading and invoking the swarm client.
#
# note: The jenkins master requires the swarm plugin before an agent can be assigned with this class.
#       This class requires an associated API user to be created on the jenkins master. After the user
#       has been created, you'll need to retrieve the user's API token. The API token is used in place of a
#       a password to authenticate a jenkins user with the jenkins master. An API token can be
#       found in the jenkins UI under the user's profile 'http://<JENKINS HOST>:<PORT>/user/<USERNAME>/configure'
#
# === Parameters
#
# [*swarm_user*]
#   The that invokes the swarm client
#
# [*agent_labels*]
#   The agent labels advertise what resources a particular jenkins agent has available.
#   This is useful if you wanted to isolate a job/task to a jenkins agent to
#   make use of any unique resouces/dependencies a particular jenkins agent may offer.
#
# [*discovery_addr*]
#   The broadcast IP address of an interface.  The swarm client uses udp to discovery to
#   discover a jenkins master on the network.
#
# [*agent_user_api_token*]
#   Used to authenticate a jenkins user with the jenkisn master.  The user is defined in:
#   'govuk_ci::master' as an 'govuk_jenkins::api_user' type.
#
# [*swarm_client_dest*]
#   Path to the swarm client binary.
#
# [*swarm_client_url*]
#   The download link of the swarm client binary.
#
class govuk_ci::agent::swarm(
  $swarm_user           = 'jenkins',
  $agent_labels         = [],
  $discovery_addr       = '10.1.6.255',
  $agent_user_api_token = undef,     # Corresponding user: 'agent_user'
  $swarm_client_dest    = '/home/jenkins/swarm-client-2.2-jar-with-dependencies.jar',
  $swarm_client_url     = undef,
) {

  include ::curl

  validate_array($agent_labels)
  $labels = join($agent_labels, ' ') # Convert the Hiera array to a space separated list

  user { $swarm_user :
    comment    => 'I run the jenkins swarm client',
    managehome => true,
    shell      => '/bin/sh',
  }

  ::curl::fetch { 'swarm_client':
    source      => $swarm_client_url,
    destination => $swarm_client_dest,
    timeout     => 10,
    verbose     => false,
    require     => User['jenkins'],
  }

  # Upstart script to manage process
  file {'jenkins-agent.conf':
    ensure  => file,
    path    => '/etc/init/jenkins-agent.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    content => template('govuk_ci/jenkins-agent.conf.erb'),
  }

}
