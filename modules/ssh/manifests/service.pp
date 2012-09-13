class ssh::service {

  service { 'ssh':
    ensure => running,
  }

}
