class puppetdb::service {

  service { 'puppetdb':
    ensure  => running,
  }

}
