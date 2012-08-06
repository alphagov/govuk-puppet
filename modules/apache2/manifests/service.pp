class apache2::service {
  service { 'apache2':
    ensure    => running,
    hasstatus => true,
    restart   => 'apache2ctl graceful',
  }

  @logstash::collector { 'apache2':
    source => 'puppet:///modules/apache2/logstash.conf',
  }
}
