class jenkins::slave inherits jenkins {

    harden::limit { 'jenkins-slave-nproc':
      domain => 'jenkins',
      type   => '-', # set both hard and soft limits
      item   => 'nproc',
      value  => '1024',
    }

    ssh_authorized_key { 'management_server_master':
      type => rsa,
      key  => extlookup('jenkins_key', 'NO_KEY_IN_EXTDATA'),
      user => 'jenkins'
    }
}
