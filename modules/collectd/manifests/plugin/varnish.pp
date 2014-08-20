# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class collectd::plugin::varnish {
  @collectd::plugin { 'varnish':
    source => 'puppet:///modules/collectd/plugins/varnish.conf',
  }
}
