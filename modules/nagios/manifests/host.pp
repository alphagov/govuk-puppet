define nagios::host (
  $ensure   = present,
  $alias    = $::fqdn,
  $address  = $::ipaddress,
  $use      = 'generic-host',
  $hostname = $title
) {
  file {"/etc/nagios3/conf.d/nagios_host_${hostname}.cfg":
    content => template('nagios/host.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}