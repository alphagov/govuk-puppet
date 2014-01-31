class monitoring::client {

  include monitoring::client::apt
  include icinga::client
  include nsca::client
  include auditd
  include collectd

  class { 'statsd':
    graphite_hostname => 'graphite.cluster',
  }

}
