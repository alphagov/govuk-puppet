define nagios::check (
  $ensure              = 'present',
  $service_description = undef,
  $check_command       = undef,
  $host_name           = $::fqdn,
  $notification_period = undef,
  $use                 = 'govuk_regular_service',
  $action_url          = undef
) {

  $check_filename = "/etc/nagios3/conf.d/nagios_host_${host_name}/${title}.cfg"

  if $ensure == 'present' {

    if $service_description == undef {
      fail("Must provide a \$service_description to Nagios::Check[${title}]")
    }

    if $check_command == undef {
      fail("Must provide a \$check_command to Nagios::Check[${title}]")
    }

    $check_content = template('nagios/service.erb')

    Nagios::Host[$host_name] -> Nagios::Check[$title]

  } else {
    $check_content = ''
  }

  file { $check_filename:
    ensure  => $ensure,
    content => $check_content,
    require => Class['nagios::package'],
    notify  => Class['nagios::service'],
  }

}
