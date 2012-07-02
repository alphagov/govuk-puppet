class ganglia::install {
  include wget
  package { 'ganglia-webfrontend': 
    ensure => 'purged' 
  }
  wget::fetch { 'ganglia-webfrontend':
    source  => "http://sourceforge.net/projects/ganglia/files/ganglia-web/3.5.0/ganglia-web-3.5.0.tar.gz/download",
    destination => "/tmp/ganglia-web-3.5.0.tar.gz"
  }
  exec { 'ganglia_webfrontend_untar':
    command => "tar zxf /tmp/ganglia-web-3.5.0.tar.gz && chown -R www-data:www-data /var/www/ganglia-web-3.5.0",
    path => "/bin",
    cwd => "/var/www/",
    unless  => "/usr/bin/test -s /var/www/ganglia-web-3.5.0",
    require => Wget::Fetch[ganglia-webfrontend]
  }
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
  file { '/etc/apache2/sites-enabled/ganglia':
    ensure  => present,
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/ganglia/apache.conf',
    require => Exec[ganglia_webfrontend_untar],
  }
  file { '/etc/ganglia/gmetad.conf':
    source  => 'puppet:///modules/ganglia/gmetad.conf',
    owner   => root,
    group   => root,
    require => Exec[ganglia_webfrontend_untar],
   }

}
