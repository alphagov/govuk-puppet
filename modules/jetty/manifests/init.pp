class jetty($version='7.6.4.v20120524'){
  include java::openjdk6::jre

  $home = '/opt'

  user { 'jetty':
    ensure     => present,
    home       => '/home/jetty',
    managehome => true,
    shell      => '/bin/bash'
  }

  wget::fetch { 'jetty_download':
    # Using the HEAnet mirror, as it's orders of magnitude faster
    source      => "https://gds-public-readable-tarballs.s3.amazonaws.com/jetty-distribution-$version.tar.gz",
    destination => "/usr/local/src/jetty-distribution-$version.tar.gz",
    before      => Exec['jetty_untar'],
  }

  exec { 'jetty_untar':
    command => "tar zxf /usr/local/src/jetty-distribution-$version.tar.gz && chown -R jetty:jetty $home/jetty-distribution-$version",
    cwd     => $home,
    creates => "$home/jetty-distribution-$version",
    path    => ['/bin',],
    notify  => Service['jetty'],
    require => User['jetty'],
  }

  file { "$home/jetty":
    ensure  => "$home/jetty-distribution-$version",
    require => Exec['jetty_untar'],
  }

  @logster::cronjob { 'jetty':
    args => 'JettyGangliaLogster /var/log/jetty/`date +\%Y_\%m_\%d.request.log`',
  }

  file { "$home/jetty/webapps":
    group   => 'deploy',
    owner   => 'jetty',
    mode    => '0664',
    require => Exec['jetty_untar'],
  }

  file { "$home/jetty/contexts/test.xml":
    ensure => absent,
  }
  file { "$home/jetty/contexts/test.d":
    ensure => absent,
    force  => true,
  }
  file { "$home/jetty/webapps/test.war":
    ensure => absent,
  }

  file { "$home/jetty/etc/jetty-webapps.xml":
    ensure  => present,
    source  => 'puppet:///modules/jetty/jetty-webapps.xml',
    require => File["$home/jetty"],
    notify  => Service['jetty'],
  }

  file { "$home/jetty/etc/jetty-contexts.xml":
    ensure  => present,
    source  => 'puppet:///modules/jetty/jetty-contexts.xml',
    require => File["$home/jetty"],
    notify  => Service['jetty'],
  }

  file { "$home/jetty/start.ini":
    ensure  => present,
    source  => 'puppet:///modules/jetty/start.ini',
    require => File["$home/jetty"],
    notify  => Service['jetty'],
  }

  file { '/var/log/jetty':
    ensure  => "$home/jetty/logs",
    require => File["$home/jetty"],
  }

  file { '/etc/init.d/jetty':
    ensure => "$home/jetty-distribution-$version/bin/jetty.sh"
  }

  service {'jetty':
    ensure     => stopped,
    enable     => false,
    hasstatus  => false,
    hasrestart => true,
    require    => File['/etc/init.d/jetty'],
  }

}
