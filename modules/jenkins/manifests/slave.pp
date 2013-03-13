class jenkins::slave inherits jenkins {

    harden::limit { 'jenkins-slave-nproc':
      domain => 'jenkins',
      type   => '-', # set both hard and soft limits
      item   => 'nproc',
      value  => '1024',
    }

}
