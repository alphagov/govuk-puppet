class postgres::ubuntu {

  case $::lsbdistcodename {
    'lucid' : {
        $version = '8.4'
    }
    'precise': {
        $version = '9.1'
    }
    default: {
        $version = '9.1'
    }
  }

  package { 'postgresql':
    ensure => present,
    name   => 'postgresql',
    notify => undef,
  }

  user { 'postgres':
    ensure  => present,
    require => Package['postgresql'],
  }

  package {[
      "postgresql-client-${version}",
      'postgresql-common',
      'postgresql-client-common',
      "postgresql-contrib-${version}"
      ]:
      ensure  => present,
      require => Package['postgresql'],
  }

  service {'postgresql':
      ensure    => running,
      enable    => true,
      hasstatus => true,
      start     => "/etc/init.d/postgresql start",
      status    => "/etc/init.d/postgresql status",
      stop      => "/etc/init.d/postgresql stop",
      restart   => "/etc/init.d/postgresql restart",
      require   => Package['postgresql-common'],
  }

  exec { "reload postgresql ${version}":
      refreshonly => true,
      command     => "/etc/init.d/postgresql reload",
  }
}
