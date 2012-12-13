class backup::offsite::monitoring {

  $offsite_fqdn = 'offsite-backup.production.alphagov.co.uk'
  $offsite_hostname = 'offsite-backup'

  nagios::host { $offsite_fqdn:
    hostalias => $offsite_fqdn,
    address   => $offsite_fqdn,
  }

  nagios::check { "check_ping_${offsite_hostname}":
    check_command       => 'check_ping!100.0,20%!500.0,60%',
    notification_period => '24x7',
    use                 => 'govuk_high_priority',
    service_description => 'unable to ping',
    host_name           => $offsite_fqdn,
  }

  nagios::check { "check_disk_${offsite_hostname}":
    check_command       => 'check_nrpe_1arg!check_xvda1',
    service_description => 'high disk usage',
    use                 => 'govuk_high_priority',
    host_name           => $offsite_fqdn,
  }

  nagios::check { "check_ssh_${offsite_hostname}":
    check_command       => 'check_ssh',
    use                 => 'govuk_high_priority',
    service_description => 'unable to ssh',
    host_name           => $offsite_fqdn,
  }

}
