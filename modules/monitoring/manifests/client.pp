class monitoring::client {

  include monitoring::client::apt
  include nagios::client
  include nsca::client
  include auditd
  include collectd

  class { 'statsd':
    graphite_hostname => 'graphite.cluster',
  }

}
