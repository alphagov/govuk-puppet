define nagios::passive_puppet_check (
  $ensure              = 'present',
  $service_description = undef,
  $host_name           = $::fqdn,
  $use                 = 'govuk_regular_service'
) {

  $check_filename = "/etc/nagios3/conf.d/nagios_host_${host_name}/passive_${title}.cfg"

  if $ensure == 'present' {

    if $service_description == undef {
      fail("Must provide a \$service_description to Nagios::Passive_puppet_check[${title}]")
    }

    $check_content = template('nagios/passive_service.erb')

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
