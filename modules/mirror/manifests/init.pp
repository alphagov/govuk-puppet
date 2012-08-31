class mirror {
  # requires wget and nginx modules

  file { '/usr/share/www':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/tmp/update-mirror.sh':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/mirror/update-mirror.sh'
  }

  # Note that this exec task will only ever run once; a decision
  # about how to run this periodically has yet to be made, so the
  # exec task is left here merely to document the mirroring process
  #The command is for testing, since it takes a loooonggg time to download the site
  exec { 'copy-to-mirror':
    creates => '/usr/share/www/www.gov.uk',
    command => '/usr/bin/wget -mE -R licence-finder https://www.gov.uk',
    cwd     => '/usr/share/www',
    require => File['/usr/share/www'],
    user    => 'www-data',
    group   => 'www-data',
    timeout => 3600, # 1 hour. wget doesn't understand ETags
  }
  cron { 'update-latest-to-mirror':
        ensure  => absent,
        user    => 'root',
        hour    => 0, # runs once a day at 00:00 hours
        command => '/tmp/update-mirror.sh',
  }
}