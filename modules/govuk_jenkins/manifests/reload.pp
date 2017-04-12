# == Class: Govuk_jenkins::Reload
#
# This class will issue a "reload-configuration" of Jenkins, which means it will
# reload any configuration changes made to disk.
#
class govuk_jenkins::reload {
  require ::govuk_jenkins::cli

  exec { 'Reload Jenkins configuration':
    command     => '/usr/local/bin/jenkins-cli reload-configuration',
    refreshonly => true,
  }
}
