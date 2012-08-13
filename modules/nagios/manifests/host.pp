define nagios::host (
  $hostalias  = $::fqdn,
  $address    = $::ipaddress,
  $use        = 'generic-host',
  $host_name  = $title
) {

  file {"/etc/nagios3/conf.d/nagios_host_${host_name}":
    ensure  => directory,
    require => Class['nagios::package'],
    notify  => Class['nagios::service'],
  }

  file {"/etc/nagios3/conf.d/nagios_host_${host_name}.cfg":
    ensure  => present,
    content => template('nagios/host.erb'),
    require => Class['nagios::package'],
    notify  => Class['nagios::service'],
  }
}
