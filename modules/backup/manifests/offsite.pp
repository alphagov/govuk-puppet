class backup::offsite {

  cron { 'offsite-backup':
    command => '/usr/local/bin/offsite-backup',
    user    => 'govuk-backup',
    hour    => 8,
    minute  => 13,
    require => File['/usr/local/bin/offsite-backup'],
  }

  file { '/usr/local/bin/offsite-backup':
    ensure => present,
    source => 'puppet:///modules/backup/usr/local/bin/offsite-backup',
    mode   => '0755',
  }

}
