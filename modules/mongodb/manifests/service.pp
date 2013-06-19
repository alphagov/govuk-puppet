class mongodb::service {

  service { 'mongodb':
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
  }

}
