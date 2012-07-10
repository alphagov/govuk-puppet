class graphite::config {
  include apache2

  file { '/var/log/graphite':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
  file { '/etc/init/graphite.conf':
    source  => 'puppet:///modules/graphite/fastcgi_graphite.conf',
  }
  file { '/etc/apache2/sites-enabled/graphite':
    ensure  => present,
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/graphite/apache.conf',
    require => Service[apache2]
  }
}