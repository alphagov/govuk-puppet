class nagios::client::checks {
  @@nagios::host { "${::govuk_class}-${::hostname}":
    hostalias => $::fqdn,
    address   => $::ipaddress,
    use       => 'generic-host',
  }

  @@nagios_service { "check_ping_${::hostname}":
    check_command       => 'check_ping!100.0,20%!500.0,60%',
    use                 => 'generic-service',
    host_name           => "${::govuk_class}-${::hostname}",
    notification_period => '24x7',
    service_description => "check ping for ${::govuk_class}-${::hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
  }

  @@nagios::check { "check_disk_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_nrpe_1arg!check_disk',
    service_description => "check disk on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_users_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_nrpe_1arg!check_users',
    service_description => "check users on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_zombies_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_nrpe_1arg!check_zombie_procs',
    service_description => "check for zombies on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_procs_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_nrpe_1arg!check_total_procs',
    service_description => "check procs on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_load_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_nrpe_1arg!check_load',
    service_description => "check load on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_ssh_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_ssh',
    service_description => "check ssh access to ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
