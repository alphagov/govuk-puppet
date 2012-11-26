class monitoring::client {
  include nagios::client
  include ganglia::client
  include graphite::client
  include logster
  include auditd

  # Disable logstash for now
  #include logstash::client
  service { 'logstash-client':
    ensure => stopped,
  }
  @@nagios::check { "check_logstash_client_running_${::hostname}":
    ensure => absent,
  }
}
