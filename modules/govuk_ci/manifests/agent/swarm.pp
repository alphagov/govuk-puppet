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
# [*fsroot*]
#   The top level directory for jenkins workspaces and other jenkins files and directories.
#   Typically $JENKINS_HOME
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
#   By default, in newer versions of Jenkins you will be unable to view another
#   users token. To get past this, temporarily set the following as an argument under
#   JAVA_ARGS in the init.d script and restart the Jenkins service:
#
#   "-Djenkins.security.ApiTokenProperty.showTokenToAdmins=true"
#
#   Ref: https://wiki.jenkins-ci.org/display/JENKINS/Features+controlled+by+system+properties
#
# [*swarm_client_package*]
#   The name of the package in our ppa (aptly repo). It also represents the name of the ppa.
#
# [*swarm_client_dest*]
#   Path to the swarm client binary.
#
# [*apt_mirror_hostname*]
#   The base url of the ppa. The value can be found in hiera
#
# [*executors*]
#   The number of executors an agent can allocate to running jobs
#
class govuk_ci::agent::swarm(
  $agent_labels         = [],
  $ci_master            = 'ci-master-1',
  $agent_user_api_token = undef,     # Corresponding user: 'jenkins_agent'
  $swarm_client_package = 'jenkins-agent',
  $swarm_client_dest    = '/usr/local/bin/jenkins-agent',
  $apt_mirror_hostname  = undef,
  $executors            = '4',
) {

  $fsroot = '/var/lib/jenkins'
  # If $fsroot is different to jenkins_home we need to manage the directory in this class

  require ::govuk_jenkins::user
  include ::govuk_jenkins::pipeline

  validate_array($agent_labels)
  $labels = join($agent_labels, ' ') # Convert the Hiera array to a space separated list

  # The apt source which hosts the package
  apt::source { $swarm_client_package :
    location     => "http://${apt_mirror_hostname}/${$swarm_client_package}",
    release      => 'trusty',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  package { $swarm_client_package :
    ensure  => '2.2',
    require => Apt::Source[$swarm_client_package],
  }

  # Upstart script to manage process
  file {'jenkins-agent.conf':
    ensure  => file,
    path    => '/etc/init/jenkins-agent.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    content => template('govuk_ci/jenkins-agent.conf.erb'),
    require => Package[$swarm_client_package],
  }

  service { $swarm_client_package :
    ensure    => running,
    provider  => upstart,
    require   => File['jenkins-agent.conf'],
    subscribe => File['jenkins-agent.conf'],
  }

}
