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
  @@nagios::passive_check { "check_backup-${title}":
    service_description => $title,
    host_name           => $::fqdn,
    freshness_threshold => $threshold_secs,
  }
}
