define nagios::passive_check (
  $service_description,
  $host_name
){
  Nagios::Host[$host_name] -> Nagios::Passive_check[$title]

  file { "/etc/nagios3/conf.d/nagios_host_${host_name}/${title}.cfg":
    ensure  => present,
    content => template('nagios/passive_service.erb'),
    notify  => Class['nagios::service'],
    require => [
      Class['nagios::package'],
      Nagios::Timeperiod['never'],
    ],
  }
}
