class jenkins::slave inherits jenkins {

    harden::limit { 'jenkins-slave-nproc':
      domain => 'jenkins',
      type   => '-', # set both hard and soft limits
      item   => 'nproc',
      value  => '1024',
    }

    $jenkins_master_ssh_key = extlookup('jenkins_key', 'NO_KEY_IN_EXTDATA')

    File["${jenkins::jenkins_home}/.ssh/authorized_keys"] {
      ensure  => present,
      content => "ssh-rsa ${jenkins_master_ssh_key} management_server_master",
    }

}
