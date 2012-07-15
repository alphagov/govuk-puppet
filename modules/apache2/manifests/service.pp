class apache2::service {
  service { 'apache2':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
  }
  file { '/etc/logstash/logstash-client/apache.conf' :
    source  => 'puppet:///modules/apache2/etc/logstash/logstash-client/apache.conf',
    require => Service ['apache2'],
    tag     => 'logstash-client'
  }
}
