class backup::offsite::monitoring {

  $offsite_host = 'offsite-backup.production.alphagov.co.uk'
  $offsite_short_name = 'offsite-backup'

  nagios::host { $offsite_host:
    hostalias => $offsite_host,
    address   => $offsite_host,
  }

  nagios::check { "check_ping_${offsite_short_name}":
    check_command       => 'check_ping!100.0,20%!500.0,60%',
    notification_period => '24x7',
    use                 => 'govuk_high_priority',
    service_description => 'unable to ping',
    host_name           => $offsite_host,
  }

  nagios::check { "check_disk_${offsite_short_name}":
    check_command       => 'check_nrpe_1arg!check_xvda1',
    service_description => 'high disk usage',
    use                 => 'govuk_high_priority',
    host_name           => $offsite_host,
  }

  nagios::check { "check_ssh_${offsite_short_name}":
    check_command       => 'check_ssh',
    use                 => 'govuk_high_priority',
    service_description => 'unable to ssh',
    host_name           => $offsite_host,
  }

}
