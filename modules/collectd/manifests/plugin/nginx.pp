# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class collectd::plugin::nginx(
  $status_url
) {
  @collectd::plugin { 'nginx':
    content => template('collectd/etc/collectd/conf.d/nginx.conf.erb'),
  }
}
