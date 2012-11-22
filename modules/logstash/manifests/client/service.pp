class logstash::client::service {
  file { '/etc/init/logstash-client.conf':
    source => 'puppet:///modules/logstash/etc/init/logstash-client.conf'
  }

  service { 'logstash-client':
    ensure   => running,
    provider => upstart,
    require  => File['/etc/init/logstash-client.conf'],
  }

  cron { 'logstash-client':
    ensure      => present,
    user        => 'root',
    hour        => [0, 8, 16],
    minute      => fqdn_rand_fixed(60),
    environment => 'PATH=/usr/sbin:/usr/bin:/sbin:/bin',
    command     => '/usr/sbin/service logstash-client restart #Restart to ensure leaking file descriptors are given up',
    require     => Service['logstash-client'];
  }

  @nagios::nrpe_config { 'check_logstash_client':
    source  => 'puppet:///modules/logstash/etc/nagios/nrpe.d/check_logstash_client.cfg',
  }

  @@nagios::check { "check_logstash_client_running_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_logstash_client_running',
    service_description => "logstash-client not running",
    host_name           => $::fqdn,
  }
}
