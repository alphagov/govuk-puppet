class mirror {

  include wget

  file { '/usr/local/bin/govuk_update_mirror':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/mirror/govuk_update_mirror'
  }

  file { '/usr/share/www':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
  }

  file { '/usr/share/www/www.gov.uk':
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    require => File['/usr/share/www'],
  }

  cron { 'update-latest-to-mirror':
    ensure  => present,
    user    => 'root',
    hour    => '0',
    minute  => '0',
    command => '/usr/local/bin/govuk_update_mirror',
    require => File['/usr/local/bin/govuk_update_mirror'],
  }

}
