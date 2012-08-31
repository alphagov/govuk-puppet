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

  # Note that this exec task will only ever run once; 
  # A cron job does the periodic updates
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
        ensure  => present,
        user    => 'root',
        hour    => 15,# The time can be changed to any convenient time of the day
        minute  => 55,# The time here is just added for the convenience of testing
        command => '/tmp/update-mirror.sh',
        require => File['/tmp/update-mirror.sh']
  }
}