class jenkins::ssh_key {
  $private_key = '/home/jenkins/.ssh/id_rsa'
  $public_key = '/home/jenkins/.ssh/id_rsa.pub'

  file { $public_key:
    checksum => md5,
    require  => [ User['jenkins'], File['/home/jenkins/.ssh'] ],
  }

  file { '/home/jenkins/.ssh':
    ensure => directory,
    mode   => '0600',
    owner  => 'jenkins',
    group  => 'jenkins',
  }

  file { '/home/jenkins/.ssh/config':
    source  => 'puppet:///modules/jenkins/dot-sshconfig',
    owner   => jenkins,
    group   => jenkins,
    mode    => '0600',
    require => [
      User['jenkins'],
      File['/home/jenkins/.ssh']
    ]
  }

  exec { 'Creating key pair for jenkins':
    command => "ssh-keygen -t rsa -C 'Provided by Puppet for jenkins' -N '' -f $private_key",
    creates => $private_key,
    require => [
      User['jenkins'],
      File['/home/jenkins/.ssh']
    ],
    user    => 'jenkins',
  }
}
