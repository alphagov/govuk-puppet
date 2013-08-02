class backup::offsite {

  cron { 'offsite-backup':
    command => '/usr/local/bin/offsite-backup',
    user    => 'govuk-backup',
    hour    => 8,
    minute  => 13,
    require => File['/usr/local/bin/offsite-backup'],
  }

  $threshold_secs = 28 * (60 * 60)
  # Also used in template.
  $service_desc   = 'offsite backup'

  file { '/usr/local/bin/offsite-backup':
    ensure  => present,
    content => template('backup/usr/local/bin/offsite-backup.erb'),
    mode    => '0755',
  }

  @@nagios::passive_check { "check_backup_offsite-${::hostname}":
    service_description => $service_desc,
    host_name           => $::fqdn,
    freshness_threshold => $threshold_secs,
  }
}
