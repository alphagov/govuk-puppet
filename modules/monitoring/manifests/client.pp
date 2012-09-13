class monitoring::client {
  include nagios::client
  include ganglia::client
  include graphite::client
  include logstash::client
  include logster
  include auditd
}
