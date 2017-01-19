# == Class: Govuk_jenkins::Safe_restart
#
# This class will issue a "safe restart" of Jenkins, which means it will only
# restart once all jobs have finished running.
#
# Note: this requires having a user enabled that has the appropriate public SSH
# key assigned to it. This should be added manually via the UI in advance
# otherwise the command will fail.
#
# === Parameters:
#
# [*jenkins_home*]
#   The home directory of the Jenkins install, and where to put the Jenkins CLI
#   jar.
#
class govuk_jenkins::safe_restart (
  $jenkins_home = '/var/lib/jenkins',
) {
  require ::govuk_jenkins

  curl::fetch { 'Jenkins CLI tool':
    source      => 'http://localhost:8080/nlpJars/jenkins-cli.jar',
    destination => "${jenkins_home}/jenkins-cli.jar",
    timeout     => 0,
    verbose     => false,
  }

  exec { 'Restart Jenkins':
    command     => "/usr/bin/java -jar ${jenkins_home}/jenkins-cli.jar -s http://localhost:8080/ -i ${jenkins_home}/.ssh/id_rsa safe-restart",
    require     => Curl::Fetch['Jenkins CLI tool'],
    refreshonly => true,
  }
}
