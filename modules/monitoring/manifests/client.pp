class monitoring::client {
  include nagios::client
  include nsca::client
  include ganglia::client
  include graphite::client
  include logster
  include auditd

  # Disable logstash for now
  #include logstash::client
  file { '/etc/init/logstash-client.conf':
    content => 'exec echo',
  }
  service { 'logstash-client':
    ensure => stopped,
  }
  @@nagios::check { "check_logstash_client_running_${::hostname}":
    ensure => absent,
  }
}
