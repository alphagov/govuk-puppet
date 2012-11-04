define nagios::host (
  $hostalias  = $::fqdn,
  $address    = $::ipaddress,
  $use        = 'generic-host',
  $host_name  = $::fqdn
) {

  file {"/etc/nagios3/conf.d/nagios_host_${title}":
    ensure  => directory,
    purge   => true,
    force   => true,
    recurse => true,
    require => Class['nagios::package'],
    notify  => Class['nagios::service'],
  }

  file {"/etc/nagios3/conf.d/nagios_host_${title}.cfg":
    ensure  => present,
    content => template('nagios/host.erb'),
    require => Class['nagios::package'],
    notify  => Class['nagios::service'],
  }
}
