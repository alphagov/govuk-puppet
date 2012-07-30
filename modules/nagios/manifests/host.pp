define nagios::host (
  $hostalias  = $::fqdn,
  $address    = $::ipaddress,
  $use        = 'generic-host',
  $host_name  = $title
) {
  file {"/etc/nagios3/conf.d/nagios_host_${host_name}":
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
  file {"/etc/nagios3/conf.d/nagios_host_${host_name}.cfg":
    ensure  => present,
    content => template('nagios/host.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
