class logstash::common {
  file { '/etc/nagios/nrpe.d/check_logstash.cfg':
      source  => 'puppet:///modules/logstash/etc/nagios/nrpe.d/check_logstash.cfg',
      require => [Service['logstash-server'],Package['nagios-nrpe-server']],
      notify  => Service['nagios-nrpe-server'],
    }
}
