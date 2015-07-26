# == Class: collectd::plugin::varnish
#
# Sets up a collectd plugin to monitor Varnish.
#
class collectd::plugin::varnish {
  @collectd::plugin { 'varnish':
    source => 'puppet:///modules/collectd/plugins/varnish.conf',
  }
}
