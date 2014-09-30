# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_jenkins::ssh_key {
  $home_dir = '/var/lib/jenkins'
  $ssh_dir = "${home_dir}/.ssh"
  $private_key = "${ssh_dir}/id_rsa"
  $public_key = "${ssh_dir}/id_rsa.pub"

  file { $public_key:
    checksum => md5,
    require  => [ User['jenkins'], File[$ssh_dir] ],
  }

  file { $ssh_dir:
    ensure => directory,
    mode   => '0600',
    owner  => 'jenkins',
    group  => 'jenkins',
  }

  exec { 'Creating key pair for jenkins':
    command => "ssh-keygen -t rsa -C 'Provided by Puppet for jenkins' -N '' -f ${private_key}",
    creates => $private_key,
    require => [
      User['jenkins'],
      File[$ssh_dir],
    ],
    user    => 'jenkins',
  }

  package { 'keychain':
    ensure => 'installed'
  }

  file { "${home_dir}/.bashrc":
    source  => 'puppet:///modules/govuk_jenkins/dot-bashrc',
    owner   => jenkins,
    group   => jenkins,
    mode    => '0700',
    require => Package['keychain'],
  }
}
