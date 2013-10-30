define backup::directory (
    $directory,
    $host_name,
    $fq_dn,
    $frequency = 'daily',
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

    file { "/etc/backup/${frequency}/directory_${name}":
        content => template('backup/directory.erb'),
        mode    => '0755',
    }

    @@icinga::passive_check { "check_backup-${fq_dn}-${sanitised_dir}-${::hostname}":
      service_description => $service_desc,
      host_name           => $::fqdn,
      freshness_threshold => $threshold_secs,
    }
}
