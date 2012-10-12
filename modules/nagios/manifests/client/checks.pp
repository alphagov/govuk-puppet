class nagios::client::checks {

  anchor { ['nagios::client::checks::begin', 'nagios::client::checks::end']: }
  include nagios::client::check_rw_rootfs
  include nagios::client::check_apt_updates
  Anchor['nagios::client::checks::begin'] -> Class['nagios::client::check_rw_rootfs'] -> Anchor['nagios::client::checks::end']

  @@nagios::check { "check_ping_${::hostname}":
    check_command       => 'check_ping!100.0,20%!500.0,60%',
    host_name           => "${::govuk_class}-${::hostname}",
    notification_period => '24x7',
    use                 => 'govuk_high_priority',
    service_description => "unable to ping ${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_disk_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_disk',
    service_description => "high disk usage on ${::govuk_class}-${::hostname}",
    use                 => 'govuk_high_priority',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_users_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_users',
    service_description => "high user logins on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_zombies_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_zombie_procs',
    service_description => "high zombie procs on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_procs_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_total_procs',
    service_description => "high total procs on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_load_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_load',
    service_description => "high load on ${::govuk_class}-${::hostname}",
    use                 => 'govuk_normal_priority',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_ssh_${::hostname}":
    check_command       => 'check_ssh',
    use                 => 'govuk_high_priority',
    service_description => "unable to ssh to ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_io_time${::hostname}":
    check_command       => 'check_ganglia_metric!diskstat_sda1_io_time!5!10',
    service_description => "high disk I/O on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_ntp_time_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_ntp_time',
    service_description => "ntp drift too high on on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
