# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define icinga::host (
  $hostalias  = $::fqdn,
  $address    = $::ipaddress,
  $use        = 'generic-host',
  $host_name  = $::fqdn
) {

  file {"/etc/icinga/conf.d/icinga_host_${title}":
    ensure  => directory,
    purge   => true,
    force   => true,
    recurse => true,
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

  file {"/etc/icinga/conf.d/icinga_host_${title}.cfg":
    ensure  => present,
    content => template('icinga/host.erb'),
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }
}
