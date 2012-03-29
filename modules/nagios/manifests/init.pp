class nagios {
  include nagios::install, nagios::service
  exec { 'fix_nagios_perms':
    command     => '/bin/chmod -R 755 /etc/nagios3',
    notify      =>  Service['nagios3'],
    refreshonly => true,
  }
  Nagios_host    <<||>> { notify => Service['nagios3'] }
  Nagios_service <<||>> { notify => Exec['fix_nagios_perms'] }
}

class nagios::install {
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
    source  => 'puppet:///modules/nagios/nagios/contacts_nagios2.cfg',
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
    ensure => present,
    owner  => nagios,
    group  => nagios
  }
  cron { 'pagerduty':
    command => '/usr/local/bin/pagerduty_nagios.pl flush',
    user    => 'nagios',
    minute  => '*',
  }
  user { 'www-data':
    groups => ['nagios']
  }
  # it's possible this is still missing running
  # dpkg-statoverride --update --add nagios www-data 2710 /var/lib/nagios3/rw
  # dpkg-statoverride --update --add nagios nagios 751 /var/lib/nagios3
}

class nagios::service {
  service { 'nagios3':
    ensure     => running,
    alias      => 'nagios',
    hasstatus  => true,
    hasrestart => true,
    require    => Class['nagios::install'],
  }
}

class nagios::client {
  include nagios::client::install, nagios::client::service
}

class nagios::client::checks {
  @@nagios_host { "${::govuk_class}-${::hostname}":
    ensure  => present,
    alias   => $::fqdn,
    address => $::ipaddress,
    use     => 'generic-host',
    target  => "/etc/nagios3/conf.d/nagios_host_${::hostname}.cfg",
  }

  @@nagios_service { "check_ping_${::hostname}":
    check_command       => 'check_ping!100.0,20%!500.0,60%',
    use                 => 'generic-service',
    host_name           => "${::govuk_class}-${::hostname}",
    notification_period => '24x7',
    service_description => "check ping for ${::govuk_class}-${::hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
  }

  @@nagios_service { "check_disk_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_nrpe_1arg!check_disk',
    service_description => "check disk on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
  }

  @@nagios_service { "check_users_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_nrpe_1arg!check_users',
    service_description => "check users on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
  }

  @@nagios_service { "check_zombies_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_nrpe_1arg!check_zombie_procs',
    service_description => "check for zombies on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
  }

  @@nagios_service { "check_procs_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_nrpe_1arg!check_total_procs',
    service_description => "check procs on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
  }

  @@nagios_service { "check_load_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_nrpe_1arg!check_load',
    service_description => "check load on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
  }

  @@nagios_service { "check_ssh_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_ssh',
    service_description => "check ssh access to ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
  }
}

class nagios::client::install {
  $nagios_client_packages = ['nagios-nrpe-plugin', 'nagios-plugins-basic', 'nagios-plugins-standard', 'nagios-nrpe-server']
  package { $nagios_client_packages: ensure => 'installed' }
  file { '/etc/nagios/nrpe.cfg':
    source  => 'puppet:///modules/nagios/nrpe.cfg',
    owner   => root,
    group   => root,
    mode    => '0640',
    notify  => Service[nagios-nrpe-server],
    require => Package[nagios-nrpe-server],
  }
  file { '/usr/local/bin/nrpe-runner':
    source => 'puppet:///modules/nagios/nrpe-runner',
    owner  => root,
    group  => root,
    mode   => '0755',
  }
  package { 'json':
    ensure   => 'installed',
    provider => gem,
  }
  file { '/etc/nagios/nrpe.d':
    ensure  => directory,
    source  => 'puppet:///modules/nagios/nrpe.d',
    recurse => true,
    purge   => true,
    force   => true,
    notify  => Service[nagios-nrpe-server],
    require => Package[nagios-nrpe-server],
  }
}

class nagios::client::service {
  service { 'nagios-nrpe-server':
    ensure     => running,
    hasrestart => true,
    hasstatus  => false,
    pattern    => '/usr/sbin/nrpe',
    require    => Class['nagios::client::install'],
  }
}
