class mirror {
  # requires wget and nginx modules

  file { '/usr/share/www':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  # Note that this exec task will only ever run once; a decision
  # about how to run this periodically has yet to be made, so the
  # exec task is left here merely to document the mirroring process
  exec { 'update-govuk-mirror':
    creates => '/usr/share/www/www.gov.uk',
    command => '/usr/bin/wget -mE -R licence-finder https://www.gov.uk',
    cwd     => '/usr/share/www',
    require => File['/usr/share/www'],
    user    => 'www-data',
    group   => 'www-data',
    timeout => 3600, # 1 hour. wget doesn't understand ETags
  }

}