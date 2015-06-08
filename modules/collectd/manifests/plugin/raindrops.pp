# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define collectd::plugin::raindrops(
  $port,
  $ensure = 'present',
) {
  include collectd::plugin::curl

  # Sanitise file and metric names.
  validate_re($title, '^[\w\-]+$')

  @collectd::plugin { "raindrops-${title}":
    ensure  => $ensure,
    content => template('collectd/etc/collectd/conf.d/raindrops.conf.erb'),
    require => Class['collectd::plugin::curl'],
  }
}
