class monitoring::client {
  include nagios::client
  include nsca::client
  include ganglia::client
  include graphite::client
  include logster
  include auditd

}
