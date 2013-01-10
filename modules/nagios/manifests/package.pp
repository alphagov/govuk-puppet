class nagios::package {

  include nginx::fcgi

  package { [
    'nagios3',
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
    ensure   => present,
    provider => 'gem',
  }

  package { 'NagAconda':
    ensure   => present,
    provider => 'pip',
  }

  file { '/usr/local/bin/check_pingdom.sh':
    source => 'puppet:///modules/nagios/usr/local/bin/check_pingdom.sh',
    mode   => '0755',
  }

  file { '/usr/local/bin/sendEmail':
    source => 'puppet:///modules/nagios/usr/local/bin/sendEmail',
    mode   => '0755',
  }

  file { '/usr/local/bin/check_ganglia_metric':
    source => 'puppet:///modules/nagios/usr/local/bin/check_ganglia_metric',
    mode   => '0755',
  }

  file { '/usr/local/bin/reversedns.py':
    source => 'puppet:///modules/nagios/usr/local/bin/reversedns.py',
    mode   => '0755',
  }

  # pagerduty stuff
  file { '/usr/local/bin/pagerduty_nagios.pl':
    source => 'puppet:///modules/nagios/usr/local/bin/pagerduty_nagios.pl',
    mode   => '0755',
  }

  # campfire stuff
  file { '/usr/local/bin/campfire_nagios':
    source => 'puppet:///modules/nagios/usr/local/bin/campfire_nagios',
    mode   => '0755',
  }

  file { '/var/log/sendEmail':
    ensure  => present,
    owner   => nagios,
    group   => nagios,
    require => Package['nagios3']
  }

  #
  # The following execs ensure that the Nagios web interface can send commands
  # to the Nagios daemon, by adjusting the permissions on the FIFO they use to
  # communicate with each other. This cannot be achieved simply by modifying
  # the permissions with Puppet, as Nagios recreates the pipe when it starts,
  # and reads the correct permissions from dpkg.
  #   - NS 2013-01-09
  #
  exec { 'dpkg-statoverride /var/lib/nagios3/rw':
    command => '/usr/sbin/dpkg-statoverride --update --add nagios www-data 2710 /var/lib/nagios3/rw',
    unless  => '/usr/sbin/dpkg-statoverride --list /var/lib/nagios3/rw',
  }

  exec { 'dpkg-statoverride /var/lib/nagios3':
    command => '/usr/sbin/dpkg-statoverride --update --add nagios nagios 751 /var/lib/nagios3',
    unless  => '/usr/sbin/dpkg-statoverride --list /var/lib/nagios3',
  }
}
