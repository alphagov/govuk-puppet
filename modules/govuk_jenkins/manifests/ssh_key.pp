# == Class: govuk_jenkins::ssh_key
#
# Sets up an SSH key pair for the specified user.
#
# === Parameters:
#
# [*private_key*]
#   A passwordless RSA private key generated with `ssh-keygen -t rsa`.
#
# [*jenkins_user*]
#   Name of the Jenkins user
#
# [*home_dir*]
#   Home directory of the Jenkins user
#
# [*aws_ssh_key_id*]
#   AWS SSH key config ID (visible in AWS console).
#
class govuk_jenkins::ssh_key (
  $private_key    = undef,
  $jenkins_user   = 'jenkins',
  $home_dir       = '/var/lib/jenkins',
  $aws_ssh_key_id = undef,
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

  file { "${ssh_dir}/config":
    content => template('govuk_jenkins/ssh-config.erb'),
    owner   => $jenkins_user,
    group   => $jenkins_user,
    mode    => '0600',
    require => File[$ssh_dir],
  }

  if $private_key {
    exec { $public_key_filename:
      command   => "ssh-keygen -y -f ${private_key_filename} > ${public_key_filename} && chmod 0644 ${public_key_filename}",
      creates   => $public_key_filename,
      user      => $jenkins_user,
      group     => $jenkins_user,
      require   => User[$jenkins_user],
      subscribe => File[$private_key_filename],
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
