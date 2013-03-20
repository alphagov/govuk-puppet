class monitoring::client {
  include nagios::client
  include nsca::client
  include ganglia::remove
  include graphite::client
  include logster
  include auditd
  include collectd

}
