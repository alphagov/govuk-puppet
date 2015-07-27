# == Class: collectd::plugin::tcpconns
#
# Sets up a collectd plugin to monitor the number of TCP connections.
#
class collectd::plugin::tcpconns {
  @collectd::plugin { 'tcpconns':
    prefix  => '00-',
  }
}
