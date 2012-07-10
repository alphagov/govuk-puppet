class nagios::client::checks {
  include nagios::client

  @@nagios::check { "check_ping_${::hostname}":
    check_command       => 'check_ping!100.0,20%!500.0,60%',
    host_name           => "${::govuk_class}-${::hostname}",
    notification_period => '24x7',
    service_description => "check ping for ${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_disk_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_disk',
    service_description => "check disk on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_users_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_users',
    service_description => "check users on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_zombies_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_zombie_procs',
    service_description => "check for zombies on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_procs_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_total_procs',
    service_description => "check procs on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_load_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_load',
    service_description => "check load on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_ssh_${::hostname}":
    check_command       => 'check_ssh',
    service_description => "check ssh access to ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_puppet_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_puppet',
    service_description => "Check puppet has run recently on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  include nagios::client::check_rw_rootfs

  @@nagios::check { "check_io_time${::hostname}":
    check_command       => 'check_ganglia_metric!diskstat_sda1_io_time!5!10',
    service_description => 'Check disk iotime is not excessive',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_ntp_time_${::hostname}":
    check_command       => 'check_ntp_time!0.5!1',
    service_description => 'Check ntp drift is not excessive',
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
