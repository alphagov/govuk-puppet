# == Class: icinga::client::checks
#
# This class provides the default checks for a client machine.
#
# === Parameters:
# [*disk_time_warn*]
#   The disk time in milliseconds that will causing a warning state.
#
# [*disk_time_critical*]
#   The disk time in milliseconds that will cause a critical state.
#
# [*disk_time_window_minutes*]
#   The duration in minutes to include in the moving average window
#   for disk time checks.
#
class icinga::client::checks (
  $disk_time_warn = 100,
  $disk_time_critical = 200,
  $disk_time_window_minutes = 5,
) {

  include icinga::client::check_cputype
  include icinga::client::check_file_not_exists
  include icinga::client::check_linux_free_memory
  include icinga::client::check_rw_rootfs
  include icinga::client::check_upstart_status

  anchor { ['icinga::client::checks::begin', 'icinga::client::checks::end']: }
  Anchor['icinga::client::checks::begin']
    -> Class['icinga::client::check_rw_rootfs']
    -> Anchor['icinga::client::checks::end']

  @icinga::nrpe_config { 'check_file_age':
    source => 'puppet:///modules/icinga/etc/nagios/nrpe.d/check_file_age.cfg',
  }

  @@icinga::check { "check_ping_${::hostname}":
    check_command       => 'check_ping!100.0,20%!500.0,60%',
    notification_period => '24x7',
    use                 => 'govuk_high_priority',
    service_description => 'unable to ping',
    host_name           => $::fqdn,
  }

  # left as a fallback in case someone forgets an individual disk check
  @@icinga::check { "check_disk_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_disk',
    service_description => 'low available disk space',
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(low-available-disk-space),
  }

  @@icinga::check { "check_root_disk_space_${::hostname}":
    check_command       => 'check_nrpe!check_disk_space_arg!20% 10% /',
    service_description => 'low available disk space on root',
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(low-available-disk-space),
  }
  @@icinga::check { "check_root_disk_inodes_${::hostname}":
    check_command       => 'check_nrpe!check_disk_inodes_arg!20% 10% /',
    service_description => 'low available disk inodes on root',
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(low-available-disk-inodes),
  }

  @@icinga::check { "check_boot_disk_space_${::hostname}":
    check_command       => 'check_nrpe!check_disk_space_arg!20% 10% /boot',
    service_description => 'low available disk space on /boot',
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
  }

  @@icinga::check { "check_users_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_users',
    service_description => 'high number of ssh sessions',
    host_name           => $::fqdn,
  }

  @@icinga::check { "check_zombies_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_zombie_procs',
    service_description => 'high zombie procs',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(high-zombie-procs),
  }

  @@icinga::check { "check_procs_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_total_procs',
    service_description => 'high total procs',
    host_name           => $::fqdn,
  }

  @@icinga::check { "check_load_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_load',
    service_description => 'high load on',
    host_name           => $::fqdn,
  }

  @@icinga::check { "check_ssh_${::hostname}":
    check_command       => 'check_ssh',
    use                 => 'govuk_high_priority',
    service_description => 'unable to ssh',
    host_name           => $::fqdn,
  }

  # Check how much time the kernel is spending reading and writing to disk. This
  # checks the median (50th percentile) time (in milliseconds) spent per second
  # performing I/O operations over the last 5 minutes. The argument to
  # movingMedian is the number of data points to include in the moving average
  # frame, calculated below as
  #
  #   (5 minutes * 60 seconds minute^-1) / 10 seconds datapoint^-1
  #
  # This will not alert on short spikes in I/O unless they are very large.
  # Instead, it is intended to alert on persistent high I/O.

  $disk_time_window_points = ($disk_time_window_minutes * 60) / 10

  @@icinga::check::graphite { "check_disk_time_${::hostname}":
    desc      => 'high disk time',
    target    => "movingMedian(sum(${::fqdn_metrics}.disk-sd?.disk_time.*),${disk_time_window_points})",
    args      => "--from ${disk_time_window_minutes}mins",
    warning   => $disk_time_warn,
    critical  => $disk_time_critical,
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(high-disk-time),
  }

  @@icinga::check { "check_ntp_time_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_ntp_time',
    service_description => 'ntp drift too high',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(ntp-drift-too-high),
  }
}
