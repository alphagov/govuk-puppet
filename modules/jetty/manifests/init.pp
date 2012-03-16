class jetty {
  include wget
  include openjdk
  include logster
  include graylogtail

  $jetty_home = '/opt'

  user { 'jetty':
    ensure     => present,
    home       => '/home/jetty',
    managehome => true,
    shell      => '/bin/bash'
  }

  wget::fetch { 'jetty_download':
    source      => "wget http://download.eclipse.org/jetty/$::jetty_version/dist/jetty-distribution-$::jetty_version.tar.gz",
    destination => "/usr/local/src/jetty-distribution-$::jetty_version.tar.gz",
  }

  exec { 'jetty_untar':
    command => "tar zxf /usr/local/src/jetty-distribution-$::jetty_version.tar.gz && chown -R jetty:jetty $::jetty_home/jetty-distribution-$::jetty_version",
    cwd     => $::jetty_home,
    creates => "$::jetty_home/jetty-distribution-$::jetty_version",
    path    => ['/bin',],
    notify  => Service['jetty'],
    require => User['jetty'],
  }

  file { "$::jetty_home/jetty":
    ensure  => "$::jetty_home/jetty-distribution-$::jetty_version",
    require => Exec['jetty_untar'],
  }

  cron { 'logster-jetty':
    command => '/usr/sbin/logster JettyGangliaLogster /var/log/jetty/`date +\%Y_\%m_\%d.request.log`',
    user    => root,
    minute  => '*/2'
  }

  graylogtail::collect { 'graylogtail-jetty':
    log_file => '/var/log/jetty/`date +\%Y_\%m_\%d.request.log`',
    facility => 'jetty',
  }

  @@nagios_service { "check_jetty_5xx_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_ganglia_metric!jetty_http_5xx!0.03!0.1',
    service_description => "check jetty error rate for ${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
  }

  file { "$::jetty_home/jetty/webapps":
    group   => 'deploy',
    owner   => 'jetty',
    mode    => '0664',
    require => Exec['jetty_untar'],
  }

  file { "$::jetty_home/jetty/contexts/test.xml":
    ensure => absent,
  }
  file { "$::jetty_home/jetty/contexts/test.d":
    ensure => absent,
  }
  file { "$::jetty_home/jetty/webapps/test.war":
    ensure => absent,
  }

  file { "$::jetty_home/jetty/etc/jetty-webapps.xml":
    ensure  => present,
    source  => 'puppet:///modules/jetty/jetty-webapps.xml',
    require => File["$::jetty_home/jetty"],
    notify  => Service['jetty'],
  }

  file { "$::jetty_home/jetty/etc/jetty-contexts.xml":
    ensure  => present,
    source  => 'puppet:///modules/jetty/jetty-contexts.xml',
    require => File["$::jetty_home/jetty"],
    notify  => Service['jetty'],
  }

  file { "$jetty_home/jetty/start.ini":
    ensure  => present,
    source  => 'puppet:///modules/jetty/start.ini',
    require => File["$::jetty_home/jetty"],
    notify  => Service['jetty'],
  }

  file { '/var/log/jetty':
    ensure  => "$::jetty_home/jetty/logs",
    require => File["$::jetty_home/jetty"],
  }

  file { '/etc/init.d/jetty':
    ensure => "$::jetty_home/jetty-distribution-$::jetty_version/bin/jetty.sh"
  }

  service {'jetty':
    ensure     => running,
    enable     => true,
    hasstatus  => false,
    hasrestart => true,
    require    => File['/etc/init.d/jetty'],
  }

}
