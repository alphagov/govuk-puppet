class icinga::service {

  service { 'icinga':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true
  }

}
