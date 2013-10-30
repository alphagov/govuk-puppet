class icinga::package {

  # icinga3-cgi has apache2 as a `Recommends:` so it may get unintentionally
  # installed. This gets rid of it in that eventually.
  include apache::remove

  include nginx::fcgi

  apt::ppa { 'ppa:formorer/icinga': }
  apt::ppa { 'ppa:formorer/icinga-web': }

  package { [
    'icinga',
    'nagios-images',
    'nagios-plugins',
    'libwww-perl',
    'libcrypt-ssleay-perl',
    'libnet-ssleay-perl',
    'libio-socket-ssl-perl',
    'nagios-nrpe-plugin',
  ]:
    ensure => present,
  }

  package { 'check_graphite':
    ensure   => '0.2.2',
    provider => 'gem',
  }

  package { 'NagAconda':
    ensure   => present,
    provider => 'pip',
  }

  file { '/usr/local/bin/sendEmail':
    source => 'puppet:///modules/icinga/usr/local/bin/sendEmail',
    mode   => '0755',
  }

  file { '/usr/local/bin/reversedns.py':
    source => 'puppet:///modules/icinga/usr/local/bin/reversedns.py',
    mode   => '0755',
  }

  # pagerduty stuff
  file { '/usr/local/bin/pagerduty_icinga.pl':
    source => 'puppet:///modules/icinga/usr/local/bin/pagerduty_icinga.pl',
    mode   => '0755',
  }

  # campfire stuff
  file { '/usr/local/bin/campfire_icinga':
    source => 'puppet:///modules/icinga/usr/local/bin/campfire_icinga',
    mode   => '0755',
  }

  file { '/var/log/sendEmail':
    ensure  => present,
    owner   => nagios,
    group   => nagios,
    require => Package['icinga']
  }

  #
  # The following execs ensure that the Nagios web interface can send commands
  # to the Nagios daemon, by adjusting the permissions on the FIFO they use to
  # communicate with each other. This cannot be achieved simply by modifying
  # the permissions with Puppet, as Nagios recreates the pipe when it starts,
  # and reads the correct permissions from dpkg.
  #   - NS 2013-01-09
  #
  exec { 'dpkg-statoverride /var/lib/nagios/rw':
    command => '/usr/sbin/dpkg-statoverride --update --add nagios www-data 2710 /var/lib/icinga/rw',
    unless  => '/usr/sbin/dpkg-statoverride --list /var/lib/icinga/rw',
    require => Package['icinga'],
  }

  exec { 'dpkg-statoverride /var/lib/icinga':
    command => '/usr/sbin/dpkg-statoverride --update --add nagios nagios 751 /var/lib/icinga',
    unless  => '/usr/sbin/dpkg-statoverride --list /var/lib/icinga',
    require => Package['icinga'],
    }
}
