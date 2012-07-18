class puppetdb::service {
  service {'puppetdb' :
    ensure    => running,
    hasstatus => false,
    pattern   => 'puppetdb.jar'
  }
}
