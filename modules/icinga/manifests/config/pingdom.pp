class icinga::config::pingdom {
  $pingdom_user     = extlookup('pingdom_user', 'UNSET')
  $pingdom_password = extlookup('pingdom_password', 'UNSET')
  $pingdom_key      = extlookup('pingdom_key', 'UNSET')

  file { '/etc/pingdom.ini':
    content => template('icinga/etc/pingdom.ini.erb'),
    owner   => 'nagios',
    mode    => '0400',
  }

  file { '/usr/local/bin/check_pingdom.py':
    source => 'puppet:///modules/icinga/usr/local/bin/check_pingdom.py',
    mode   => '0755',
  }
}
