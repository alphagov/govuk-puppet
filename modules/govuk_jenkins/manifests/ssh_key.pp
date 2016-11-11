# == Class: govuk_jenkins::ssh_key
#
# Sets up an SSH key pair for the specified user.
#
# === Parameters:
#
# [*private_key*]
#   A passwordless RSA private key generated with `ssh-keygen -t rsa`.
#
# [*public_key*]
#   The public key that matches `$private_key`.
#
# [*jenkins_user*]
#   Name of the Jenkins user
#
# [*home_dir*]
#   Home directory of the Jenkins user
#
class govuk_jenkins::ssh_key (
  $private_key  = undef,
  $public_key   = undef,
  $jenkins_user = 'jenkins',
  $home_dir     = '/var/lib/jenkins',
) {
  $ssh_dir = "${home_dir}/.ssh"
  $private_key_filename = "${ssh_dir}/id_rsa"
  $public_key_filename = "${ssh_dir}/id_rsa.pub"

  file { $ssh_dir:
    ensure => directory,
    mode   => '0600',
    owner  => $jenkins_user,
    group  => $jenkins_user,
  }

  if $private_key and $public_key {
    file { $public_key_filename:
      content => "ssh-rsa ${public_key}",
      mode    => '0644',
      owner   => $jenkins_user,
      group   => $jenkins_user,
      require => User[$jenkins_user],
    }

    file { $private_key_filename:
      content => $private_key,
      mode    => '0600',
      owner   => $jenkins_user,
      group   => $jenkins_user,
      require => User['jenkins'],
    }
  } else {
    exec { 'Creating key pair for jenkins':
      command => "ssh-keygen -t rsa -C 'Provided by Puppet for ${jenkins_user}' -N '' -f ${private_key_filename}",
      creates => $private_key_filename,
      require => [
        User[$jenkins_user],
        File[$ssh_dir],
      ],
      user    => $jenkins_user,
    }
  }

  package { 'keychain':
    ensure => 'installed',
  }

  file { "${home_dir}/.profile":
    ensure  => file,
    source  => 'puppet:///modules/govuk_jenkins/dot-profile',
    owner   => $jenkins_user,
    group   => $jenkins_user,
    mode    => '0700',
    notify  => Class['jenkins::service'],
    require => Package['keychain'],
  }
}
