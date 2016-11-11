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
  $private_key    = undef,
  $public_key     = undef,
) {
  user { $username:
    ensure     => present,
    home       => $home_directory,
    managehome => true,
    shell      => '/bin/bash',
  }

  class { 'govuk_jenkins::ssh_key':
    private_key  => $private_key,
    public_key   => $public_key,
    jenkins_user => $username,
    home_dir     => $home_directory,
  }

  file { "${home_directory}/.gitconfig":
    source  => 'puppet:///modules/govuk_jenkins/dot-gitconfig',
    owner   => $username,
    group   => $username,
    mode    => '0644',
    require => User[$username],
  }

}
