# == Class: govuk_jenkins::user
#
# Configure the Jenkins user and home directory
#
# === Parameters:
#
# [*home_directory*]
#   The home directory of the user
#
# [*username*]
#   The username you wish to use
#
class govuk_jenkins::user (
  $home_directory = '/var/lib/jenkins',
  $username       = 'jenkins',
) {
  user { $username:
    ensure     => present,
    home       => $home_directory,
    managehome => true,
    shell      => '/bin/bash',
  }

  file { "${home_directory}/.gitconfig":
    source  => 'puppet:///modules/govuk_jenkins/dot-gitconfig',
    owner   => $username,
    group   => $username,
    mode    => '0644',
    require => User[$username],
  }

}
