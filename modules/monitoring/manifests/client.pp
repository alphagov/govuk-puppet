class monitoring::client {

  include monitoring::client::apt
  include nagios::client
  include nsca::client
  include statsd
  include logster
  include auditd
  include collectd

}
