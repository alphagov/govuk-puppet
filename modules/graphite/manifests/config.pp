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
}