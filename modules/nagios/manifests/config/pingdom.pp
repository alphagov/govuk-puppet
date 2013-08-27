class nagios::config::pingdom {
  $pingdom_user     = extlookup('pingdom_user', 'UNSET')
  $pingdom_password = extlookup('pingdom_password', 'UNSET')
  $pingdom_key      = extlookup('pingdom_key', 'UNSET')

  file { '/etc/pingdom.ini':
    content => template('nagios/etc/pingdom.ini.erb'),
    owner   => 'nagios',
    mode    => '0400',
  }

  file { '/usr/local/bin/check_pingdom.py':
    source => 'puppet:///modules/nagios/usr/local/bin/check_pingdom.py',
    mode   => '0755',
  }

  file {[
    '/usr/local/bin/check_pingdom.sh',
    '/etc/pingdom.sh'
    ]:
    ensure => absent,
  }
}
