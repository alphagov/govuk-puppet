define nagios::check (
  $use                  = 'generic-service',
  $host_name            = $::hostname,
  $service_description,
  $check_command
) {
  file {"/etc/nagios3/conf.d/nagios_host_${host_name}/${title}.cfg":
    ensure  => present,
    content => template('nagios/service.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
  Nagios::Host[$host_name] -> Nagios::Check[$title]
}
