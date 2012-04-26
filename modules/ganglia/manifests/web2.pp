class ganglia::web2 {
  file { '/var/www/ganglia2':
    ensure  => directory,
    recurse => true,
    purge   => false,
    force   => true,
    owner   => www-data,
    group   => www-data,
    source  => 'puppet:///modules/ganglia/ganglia2',
    require => Class['ganglia::install'],
  }
  file { '/var/lib/ganglia/dwoo':
    ensure  => directory,
    owner   => www-data,
    group   => www-data,
  }
  file { '/var/lib/ganglia/conf':
    ensure  => directory,
    owner   => www-data,
    group   => www-data,
  }
}
