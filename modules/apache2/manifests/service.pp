class apache2::service {
  include logstash::client
  service { 'apache2':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
  }
  file { '/etc/logstash/logstash-client/apache.conf' :
    source  => 'puppet:///modules/apache2/etc/logstash/logstash-client/apache.conf',
    require => [Service ['apache2'],Class['logstash::client::service']]
  }
}
