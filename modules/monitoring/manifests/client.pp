class monitoring::client {
  include nagios::client
  include nsca::client
  include statsd
  include logster
  include auditd
  include collectd

}
