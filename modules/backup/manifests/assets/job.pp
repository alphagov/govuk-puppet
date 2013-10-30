define backup::assets::job(
  $asset_path,
  $hour,
  $minute
){


  cron { $title:
    command => "/usr/local/bin/memstore-backup.sh -d ${asset_path} -c /etc/govuk/memstore-credentials -f ${::fqdn} -s ${title} -n nagios.cluster",
    user    => 'root',
    hour    => $hour,
    minute  => $minute,
    require => File['/usr/local/bin/memstore-backup.sh'],
  }

  $threshold_secs = 28 * (60 * 60)
  @@icinga::passive_check { "check_backup-${title}-${::hostname}":
    service_description => $title,
    host_name           => $::fqdn,
    freshness_threshold => $threshold_secs,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#asset-backup-failed',
  }
}
