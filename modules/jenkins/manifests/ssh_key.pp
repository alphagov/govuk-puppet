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
