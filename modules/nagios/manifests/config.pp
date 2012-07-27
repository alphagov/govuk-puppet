class nagios::config {
  file { '/etc/nagios3/conf.d/check_ganglia_nagios2.cfg':
    source  => 'puppet:///modules/nagios/nagios/check_ganglia_nagios2.cfg',
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
  file { '/etc/nagios3/conf.d/generic-host_nagios2.cfg':
    source  => 'puppet:///modules/nagios/nagios/generic-host_nagios2.cfg',
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
  file { '/etc/nagios3/conf.d/check_http_nagios2.cfg':
    source  => 'puppet:///modules/nagios/nagios/check_http_nagios2.cfg',
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

  # This file is absent because it is superceded by the nagios::check immediately following.
  file { '/etc/nagios3/conf.d/localhost_service.cfg':
    ensure  => absent,
    notify  => Service[nagios3],
  }

  @@nagios::check {'check_smokey':
    check_command       => 'run_smokey_tests',
    service_description => 'Run small suite of functional tests',
    host_name           => "${::govuk_class}-${::hostname}"
  }

  # This file is absent because it is superceded by the nagios::timeperiods immediately following.
  file { '/etc/nagios3/conf.d/timeperiods_nagios2.cfg':
    ensure  => absent,
    notify  => Service[nagios3],
  }

  nagios::timeperiod {'24x7':
    timeperiod_alias     => '24 Hours A Day, 7 Days A Week',
    sun                  => '00:00-24:00',
    mon                  => '00:00-24:00',
    tue                  => '00:00-24:00',
    wed                  => '00:00-24:00',
    thu                  => '00:00-24:00',
    fri                  => '00:00-24:00',
    sat                  => '00:00-24:00',
  }

  nagios::timeperiod {'workhours':
    timeperiod_alias     => 'Standard Work Hours',
    mon                  => '09:00-17:00',
    tue                  => '09:00-17:00',
    wed                  => '09:00-17:00',
    thu                  => '09:00-17:00',
    fri                  => '09:00-09:30',
  }

  nagios::timeperiod {'nonworkhours':
    timeperiod_alias     => 'Non-Work Hours',
    sun                  => '00:00-24:00',
    mon                  => '00:00-09:00,16:00-24:00',
    tue                  => '00:00-09:00,16:00-24:00',
    wed                  => '00:00-09:00,16:00-24:00',
    thu                  => '00:00-09:00,16:00-24:00',
    fri                  => '00:00-09:00,09:30-24:00',
    sat                  => '00:00-24:00',
  }

  nagios::timeperiod {'never':
    timeperiod_alias     => 'Never'
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
  file {['/etc/nagios3/conf.d/services_nagios2.cfg',
        '/etc/nagios3/conf.d/host-gateway_nagios3.cfg',
        '/etc/nagios3/conf.d/extinfo_nagios2.cfg',
        '/etc/nagios3/conf.d/contacts_nagios2.cfg',
        '/etc/nagios3/conf.d/generic-service_nagios2.cfg',
        '/etc/nagios3/conf.d/localhost_nagios2']:
    ensure => absent,
  }

  #TODO: extlookup or hiera for email addresses?
  $contact_email = $::govuk_platform ? {
      production => 'monitoring-ec2production@digital.cabinet-office.gov.uk',
      preview    => 'monitoring-ec2preview@digital.cabinet-office.gov.uk',
      default    => 'root@localhost',
    }
  nagios::contact {'monitoring_google_group':
    email => $contact_email
  }

  $pager_fake_email = $::govuk_platform ? {
      production => 'monitoring-ec2production+pager@digital.cabinet-office.gov.uk',
      preview    => 'monitoring-ec2preview+pager@digital.cabinet-office.gov.uk',
      default    => 'root@localhost',
    }
  nagios::contact {'pager_workhours':
    email                       => $pager_fake_email,
    service_notification_options=> 'c',
    notification_period         => 'workhours'
  }

  nagios::contact {'pager_nonworkhours':
    email                       => $pager_fake_email,
    service_notification_options=> 'c',
    notification_period         => 'nonworkhours',
  }

  nagios::contact_group {'emergencies':
    group_alias => 'Contacts for emergency situations',
    members     => ['monitoring_google_group','pager_nonworkhours','pager_workhours'],
  }

  nagios::contact_group {'regular':
    group_alias => 'Contacts for regular alerts',
    members     => ['monitoring_google_group'],
  }

  nagios::service_template {'govuk_emergency_service':
    contact_groups => ['emergencies']
  }

  nagios::service_template {'govuk_regular_service':
    contact_groups => ['regular']
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
