class collectd::plugin::varnish {
  @collectd::plugin { 'varnish':
    source => 'puppet:///modules/collectd/plugins/varnish.conf',
  }
}
