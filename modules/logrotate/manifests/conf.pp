# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define logrotate::conf (
  $matches,
  $days_to_keep = '31',
  $ensure = 'present',
) {

  file { "/etc/logrotate.d/${title}":
    ensure  => $ensure,
    content => template('logrotate/logrotate.conf.erb'),
    require => Package['logrotate'],
  }

}
