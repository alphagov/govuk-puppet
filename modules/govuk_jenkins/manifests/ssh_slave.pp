# == Define: Govuk_jenkins::Ssh_slave
#
# Create an SSH slave that the Jenkins master can use to build jobs
#
# === Parameters:
#
# [*agent_hostname*]
#   The hostname of the agent that the master connects to.
#
# [*credentials_id*]
#   This is a uniquely generated ID that is created when you create a set of
#   credentials. The ID is linked to the specific Jenkins instance, so must
#   be created manually before being added to this defined type.
#
# [*labels*]
#  This string represents the labels to apply to the agent.
#
# [*description*]
#   Describe what the agent is used for.
#
# [*executors*]
#   Set how many jobs the instance can build at any one time.
#
# [*ssh_port*]
#   Set the SSH port that the master connects to.
#
# [*jenkins_home*]
#   Home directory of the Jenkins user, which also sets the root directory of
#   where builds take place.
#
# [*jenkins_user*]
#   The user which the master connects to the agent over SSH as.
#
define govuk_jenkins::ssh_slave (
  $agent_hostname,
  $credentials_id,
  $labels = undef,
  $description = 'Generic build agent',
  $executors = 4,
  $ssh_port = 22,
  $jenkins_home = '/var/lib/jenkins',
  $jenkins_user = 'jenkins',
) {

  $agent_name = $title

  file { "${jenkins_home}/nodes/${agent_name}":
    ensure  => directory,
    owner   => $jenkins_user,
    group   => $jenkins_user,
    mode    => '0775',
    require => File["${jenkins_home}/nodes"],
  }

  file { "${jenkins_home}/nodes/${agent_name}/config.xml":
    ensure  => present,
    content => template('govuk_jenkins/ssh_slave_config.xml.erb'),
    owner   => $jenkins_user,
    group   => $jenkins_user,
    notify  => Class['Govuk_jenkins::Reload'],
  }

  include icinga::client::check_jenkins_agent
  @@icinga::check { "check_jenkins_agent_status_${agent_name}":
    check_command       => "check_nrpe!check_jenkins_agent!${agent_name}",
    service_description => "${title} is not connected to the Jenkins master",
    host_name           => $::fqdn,
  }

}
