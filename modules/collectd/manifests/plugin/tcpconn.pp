# == Define: collectd::plugin::tcpconn
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
# [*ensure*]
#
define collectd::plugin::tcpconn(
  $incoming,
  $outgoing,
  $ensure = 'present',
) {

  @collectd::plugin { "tcpconn-${title}":
    ensure  => $ensure,
    content => template('collectd/etc/collectd/conf.d/tcpconn.conf.erb'),
    require => Collectd::Plugin['tcpconns'],
  }
}
