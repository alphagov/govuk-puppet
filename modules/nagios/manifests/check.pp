define nagios::check (
  $service_description,
  $check_command,
  $use                  = 'govuk_regular_service',
  $host_name            = $::fqdn,
  $notification_period  = undef
) {

  $service_description_schema = {
    'type'    => 'str',
    'pattern' => '/^[^\']*$/'
  }
  # can't work out how to get puppet to see the gem when running on the puppetmaster
  #kwalify($service_description_schema, $service_description)

  file {"/etc/nagios3/conf.d/nagios_host_${host_name}/${title}.cfg":
    ensure  => present,
    content => template('nagios/service.erb'),
    require => Class['nagios::package'],
    notify  => Class['nagios::service'],
  }

  Nagios::Host[$host_name] -> Nagios::Check[$title]

}
