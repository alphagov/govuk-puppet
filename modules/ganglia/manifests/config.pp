class ganglia::config {
  file { '/var/lib/ganglia/dwoo':
    ensure  => directory,
    owner   => www-data,
    group   => www-data,
    require => Exec[ganglia_webfrontend_untar],
  }
  file { '/var/lib/ganglia/dwoo/compiled':
    ensure  => directory,
    owner   => www-data,
    group   => www-data,
    require => Exec[ganglia_webfrontend_untar],
  }
  file { '/var/lib/ganglia/dwoo/cache':
    ensure  => directory,
    owner   => www-data,
    group   => www-data,
    require => Exec[ganglia_webfrontend_untar],
  }
  file { '/var/lib/ganglia/conf':
    ensure  => directory,
    owner   => www-data,
    group   => www-data,
    require => Exec[ganglia_webfrontend_untar],
  }

  apache2::site { 'ganglia':
    source => 'puppet:///modules/ganglia/apache.conf',
  }

  file { '/etc/ganglia/htpasswd.ganglia':
    ensure  => present,
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/ganglia/htpasswd.ganglia',
    require => Exec[ganglia_webfrontend_untar],
  }
  file { '/etc/ganglia/gmetad.conf':
    source  => 'puppet:///modules/ganglia/gmetad.conf',
    owner   => root,
    group   => root,
    require => Exec[ganglia_webfrontend_untar],
  }

}
