# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define backup::directory (
    $directory,
    $host_name,
    $fq_dn,
    $frequency = 'daily',
    $priority = undef,
    $versioned = false
    ) {

    # TODO: Requires threshold logic for other frequency periods. We don't
    # currently use these, so deferring this work.
    if $frequency != 'daily' {
      fail('"daily" is currently the only supported frequency')
    }

    $sanitised_dir  = regsubst($directory, '/', '_', 'G')
    $threshold_secs = 28 * (60 * 60)
    # Also used in template.
    $service_desc   = "backup ${fq_dn}:${directory}"

    if $priority {
      $filename = "/etc/backup/${frequency}/${priority}_directory_${name}"
    }
    else {
      $filename = "/etc/backup/${frequency}/directory_${name}"
    }

    file { $filename:
        content => template('backup/directory.erb'),
        mode    => '0755',
    }

    @@icinga::passive_check { "check_backup-${fq_dn}-${sanitised_dir}-${::hostname}":
      service_description => $service_desc,
      host_name           => $::fqdn,
      freshness_threshold => $threshold_secs,
      action_url          => 'https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!searchin/machine.email.plat1/backup-1$20run-parts$20$2Fetc$2Fbackup$2Fdaily%7Csort:date',
      notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html?highlight=backup#offsite-backups'
    }
}
