class nagios::install {
  include apache2
  package {
    'nagios3': ensure              => 'installed';
    'nagios-images': ensure        => 'installed';
    'nagios-plugins': ensure       => 'installed';
    'python-setuptools': ensure    => 'installed';
    'libwww-perl': ensure          => 'installed';
    'libcrypt-ssleay-perl': ensure => 'installed';

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
  file { '/usr/local/bin/pagerduty_nagios.pl':
    source => 'puppet:///modules/nagios/pagerduty_nagios.pl',
    owner  => root,
    group  => root,
    mode   => '0755',
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
  file { '/etc/nagios3/conf.d/check_ganglia_nagios2.cfg':
    source  => 'puppet:///modules/nagios/nagios/check_ganglia_nagios2.cfg',
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
  file { '/etc/nagios3/conf.d/check_smokey.cfg':
    source  => 'puppet:///modules/nagios/nagios/check_smokey.cfg',
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
  file { '/etc/nagios3/conf.d/pagerduty_nagios.cfg':
    source  => 'puppet:///modules/nagios/pagerduty_nagios.cfg',
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }

  file { '/etc/nagios3/conf.d/localhost_service.cfg':
    source  => 'puppet:///modules/nagios/nagios/localhost_service.cfg',
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
  file { '/etc/nagios3/cgi.cfg':
    source  => 'puppet:///modules/nagios/nagios/cgi.cfg',
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
  file { '/etc/nagios3/conf.d/hostgroups_nagios2.cfg':
    source  => 'puppet:///modules/nagios/nagios/hostgroups_nagios2.cfg',
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
  file { '/etc/nagios3/conf.d/services_nagios2.cfg':
    ensure => absent,
  }
  file { '/etc/nagios3/conf.d/host-gateway_nagios3.cfg':
    ensure => absent,
  }
  file { '/etc/nagios3/conf.d/extinfo_nagios2.cfg':
    ensure => absent,
  }
  file { '/etc/nagios3/conf.d/contacts_nagios2.cfg':
    source  => "puppet:///modules/nagios/contacts_nagios2_${::govuk_platform}.cfg",
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
  file { '/etc/nagios3/resource.cfg':
    source  => 'puppet:///modules/nagios/nagios/resource.cfg',
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
  file { '/etc/nagios3/commands.cfg':
    source  => 'puppet:///modules/nagios/nagios/commands.cfg',
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
  file { '/etc/nagios3/nagios.cfg':
    source  => 'puppet:///modules/nagios/nagios/nagios.cfg',
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
  file { '/etc/nagios3/htpasswd.users':
    source  => 'puppet:///modules/nagios/nagios/htpasswd.users',
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
  file { '/var/log/sendEmail':
    ensure  => present,
    owner   => nagios,
    group   => nagios,
    require => Package[nagios3],
  }
  file { '/etc/nagios3/apache2.conf':
    source => 'puppet:///modules/nagios/etc/nagios3/apache2.conf',
  }
  file { '/etc/apache2/conf.d/nagios3.conf':
    ensure  => link,
    target  => '/etc/nagios3/apache2.conf',
    require => Service[apache2]
  }
  cron { 'pagerduty':
    command => '/usr/local/bin/pagerduty_nagios.pl flush',
    user    => 'nagios',
    minute  => '*',
    require => Package[nagios3],
  }
  user { 'www-data':
    groups  => ['nagios'],
    require => Package[nagios3],
  }
  # it's possible this is still missing running
  # dpkg-statoverride --update --add nagios www-data 2710 /var/lib/nagios3/rw
  # dpkg-statoverride --update --add nagios nagios 751 /var/lib/nagios3
}
