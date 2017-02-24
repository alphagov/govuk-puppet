# == Class: Govuk_jenkins::Reload
#
# This class will issue a "reload-configuration" of Jenkins, which means it will
# reload any configuration changes made to disk.
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
class govuk_jenkins::reload (
  $jenkins_home = '/var/lib/jenkins',
) {
  require ::govuk_jenkins

  curl::fetch { 'Jenkins CLI tool':
    source      => 'http://localhost:8080/jnlpJars/jenkins-cli.jar',
    destination => "${jenkins_home}/jenkins-cli.jar",
    timeout     => 0,
    verbose     => false,
  }

  exec { 'Reload Jenkins configuration':
    command     => "/usr/bin/java -jar ${jenkins_home}/jenkins-cli.jar -s http://localhost:8080/ -i ${jenkins_home}/.ssh/id_rsa reload-configuration",
    require     => Curl::Fetch['Jenkins CLI tool'],
    refreshonly => true,
  }
}
