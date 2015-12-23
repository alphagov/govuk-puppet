# == Class: backup::offsite::monitoring
#
# Provides monitoring checks for the offsite backup machine.
#
# === Parameters
#
# [*offsite_fqdn*]
#   FQDN of the off-site backup machine to back data up to
#
# [*offsite_hostname*]
#   Descriptive hostname for use in Icinga check - eg "backup0.provider0"
#
class backup::offsite::monitoring(
  $offsite_fqdn,
  $offsite_hostname,
){

  icinga::host { $offsite_fqdn:
    hostalias => $offsite_fqdn,
    address   => $offsite_fqdn,
  }

  icinga::check { "check_disk_${offsite_hostname}":
    check_command       => 'check_nrpe_1arg!check_disk',
    service_description => 'low available disk space',
    use                 => 'govuk_high_priority',
    host_name           => $offsite_fqdn,
  }

  icinga::check { "check_disk_backup-data_${offsite_hostname}":
    check_command       => 'check_nrpe_1arg!check_disk_backup-data',
    service_description => 'low available disk space /srv/backup-data',
    use                 => 'govuk_high_priority',
    host_name           => $offsite_fqdn,
  }

  icinga::check { "check_disk_backup-assets_${offsite_hostname}":
    check_command       => 'check_nrpe_1arg!check_disk_backup-assets',
    service_description => 'low available disk space /srv/backup-assets',
    use                 => 'govuk_high_priority',
    host_name           => $offsite_fqdn,
  }

  icinga::check { "check_disk_logs-backup_${offsite_hostname}":
    check_command       => 'check_nrpe_1arg!check_disk_logs-backup',
    service_description => 'low available disk space /srv/logs-backup',
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
