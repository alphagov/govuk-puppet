class nagios::package {
  include apache2
  package {
    'nagios3': ensure              => 'installed';
    'nagios-images': ensure        => 'installed';
    'nagios-plugins': ensure       => 'installed';
    'libwww-perl': ensure          => 'installed';
    'libcrypt-ssleay-perl': ensure => 'installed';
  }

  file { '/usr/local/bin/sendEmail':
    source => 'puppet:///modules/nagios/sendEmail',
    owner  => root,
    group  => root,
    mode   => '0755',
  }
  exec { '/usr/bin/easy_install nagaconda':
    creates => '/usr/local/lib/python2.6/dist-packages/NagAconda-0.1.4-py2.6.egg',
    require => Package['python-setuptools'],
  }
  file { '/usr/local/bin/check_ganglia_metric':
    source => 'puppet:///modules/nagios/check_ganglia_metric',
    owner  => root,
    group  => root,
    mode   => '0755',
  }
  file { '/usr/local/bin/reversedns.py':
    source => 'puppet:///modules/nagios/reversedns.py',
    owner  => root,
    group  => root,
    mode   => '0755',
  }
  file { '/var/log/sendEmail':
    ensure  => present,
    owner   => nagios,
    group   => nagios,
    require => Package[nagios3],
  }

  # pagerduty stuff
  file { '/usr/local/bin/pagerduty_nagios.pl':
    source => 'puppet:///modules/nagios/pagerduty_nagios.pl',
    owner  => root,
    group  => root,
    mode   => '0755',
  }
}
