# == Class: govuk_jenkins::ssh_key
#
# Sets up an SSH key pair for the jenkins user.
#
# === Parameters:
#
# [*private_key*]
#   A passwordless RSA private key generated with `ssh-keygen -t rsa`.
#
# [*public_key*]
#   The public key that matches `$private_key`.
#
class govuk_jenkins::ssh_key (
  $private_key = undef,
  $public_key = undef,
) {
  $home_dir = '/var/lib/jenkins'
  $ssh_dir = "${home_dir}/.ssh"
  $private_key_filename = "${ssh_dir}/id_rsa"
  $public_key_filename = "${ssh_dir}/id_rsa.pub"

  file { $ssh_dir:
    ensure => directory,
    mode   => '0600',
    owner  => 'jenkins',
    group  => 'jenkins',
  }

  if $private_key and $public_key {
    file { $public_key_filename:
      content => "ssh-rsa ${public_key}",
      mode    => '0644',
      owner   => 'jenkins',
      group   => 'jenkins',
      require => User['jenkins'],
    }

    file { $private_key_filename:
      content => $private_key,
      mode    => '0600',
      owner   => 'jenkins',
      group   => 'jenkins',
      require => User['jenkins'],
    }
  } else {
    exec { 'Creating key pair for jenkins':
      command => "ssh-keygen -t rsa -C 'Provided by Puppet for jenkins' -N '' -f ${private_key_filename}",
      creates => $private_key_filename,
      require => [
        User['jenkins'],
        File[$ssh_dir],
      ],
      user    => 'jenkins',
    }
  }

  package { 'keychain':
    ensure => 'installed',
  }

  file { "${home_dir}/.profile":
    ensure  => file,
    source  => 'puppet:///modules/govuk_jenkins/dot-profile',
    owner   => jenkins,
    group   => jenkins,
    mode    => '0700',
    notify  => Class['jenkins::service'],
    require => Package['keychain'],
  }
}
