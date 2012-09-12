class nagios::package {

  include nginx::fcgi

  package { [
    'nagios3',
    'nagios-images',
    'nagios-plugins',
    'libwww-perl',
    'libcrypt-ssleay-perl',
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

  file { '/var/log/sendEmail':
    ensure  => present,
    owner   => nagios,
    group   => nagios,
    require => Package['nagios3']
  }

  file { '/var/lib/nagios3/rw':
    ensure  => directory,
    mode    => '2710',
    owner   => nagios,
    group   => www-data,
    require => Package['nagios3']
  }

}
