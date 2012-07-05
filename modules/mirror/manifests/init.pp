class mirror {
  # requires wget and nginx modules

  file { '/usr/share/www':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  exec { 'update-govuk-mirror':
    creates => '/usr/share/www/www.gov.uk',
    command => '/usr/bin/wget -mE https://www.gov.uk',
    cwd     => '/usr/share/www',
    require => File['/usr/share/www'],
    user    => 'www-data',
    group   => 'www-data',
    timeout => 0, #takes forever, and wget has no respect for ETags :(
  }

}