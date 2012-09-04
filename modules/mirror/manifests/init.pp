class mirror {
  # requires wget and nginx modules

  file { '/usr/share/www':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/usr/local/bin/govuk_update_mirror':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/mirror/govuk_update_mirror'
  }
  file { '/usr/share/www/www.gov.uk':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
  }
  cron { 'update-latest-to-mirror':
        ensure  => present,
        user    => 'root',
        hour    => 15,# The time can be changed to any convenient time of the day
        minute  => 55,# The time here is just added for the convenience of testing
        command => '/usr/local/bin/govuk_update_mirror',
        require => File['/usr/local/bin/govuk_update_mirror'],
  }
}