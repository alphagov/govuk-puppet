class nagios::package {

  include apache2

  package {
    'nagios3': ensure              => 'installed';
    'nagios-images': ensure        => 'installed';
    'nagios-plugins': ensure       => 'installed';
    'libwww-perl': ensure          => 'installed';
    'libcrypt-ssleay-perl': ensure => 'installed';
  }

  file { '/etc/nagios3/conf.d':
    ensure  => directory,
    purge   => true,
    force   => true,
    recurse => true,
    require => Package['nagios3'],
  }

  file { '/usr/local/bin/sendEmail':
    source => 'puppet:///modules/nagios/sendEmail',
    mode   => '0755',
  }

  exec { '/usr/bin/easy_install nagaconda':
    creates => '/usr/local/lib/python2.6/dist-packages/NagAconda-0.1.4-py2.6.egg',
    require => Package['python-setuptools'],
  }

  file { '/usr/local/bin/check_ganglia_metric':
    source => 'puppet:///modules/nagios/check_ganglia_metric',
    mode   => '0755',
  }

  file { '/usr/local/bin/reversedns.py':
    source => 'puppet:///modules/nagios/reversedns.py',
    mode   => '0755',
  }

  file { '/var/log/sendEmail':
    ensure  => present,
    owner   => nagios,
    group   => nagios,
  }

  # pagerduty stuff
  file { '/usr/local/bin/pagerduty_nagios.pl':
    source => 'puppet:///modules/nagios/pagerduty_nagios.pl',
    mode   => '0755',
  }

}
