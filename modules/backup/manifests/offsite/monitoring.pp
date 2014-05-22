class backup::offsite::monitoring {

  $offsite_fqdn = 'backup0.backup.provider1.production.govuk.service.gov.uk'
  $offsite_hostname = 'backup0.provider1'

  icinga::host { $offsite_fqdn:
    hostalias => $offsite_fqdn,
    address   => $offsite_fqdn,
  }

  icinga::check { "check_disk_${offsite_hostname}":
    check_command       => 'check_nrpe_1arg!check_disk',
    service_description => 'high disk usage',
    use                 => 'govuk_high_priority',
    host_name           => $offsite_fqdn,
  }

  icinga::check { "check_disk_backup-data_${offsite_hostname}":
    check_command       => 'check_nrpe_1arg!check_disk_backup-data',
    service_description => 'high disk usage',
    use                 => 'govuk_high_priority',
    host_name           => $offsite_fqdn,
  }

  icinga::check { "check_disk_logs-backup_${offsite_hostname}":
    check_command       => 'check_nrpe_1arg!check_disk_logs-backup',
    service_description => 'high disk usage',
    use                 => 'govuk_high_priority',
    host_name           => $offsite_fqdn,
  }

  icinga::check { "check_ssh_${offsite_hostname}":
    check_command       => 'check_ssh',
    use                 => 'govuk_high_priority',
    service_description => 'unable to ssh',
    host_name           => $offsite_fqdn,
  }

}
