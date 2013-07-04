# == Define: collectd::plugin::tcpconns
#
# Counts the number of TCP connections to or from a specified port. See collectd documentation for
# more information:
#
# http://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_tcpconns
#
# === Parameters
#
# [*incoming*]
# [*outgoing*]
#
define collectd::plugin::tcpconns($incoming, $outgoing) {

  @collectd::plugin { "tcpconns-${title}":
    content => template('collectd/etc/collectd/conf.d/tcpconns.conf.erb'),
  }
}
