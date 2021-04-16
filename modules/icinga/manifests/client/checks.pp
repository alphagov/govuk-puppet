# == Class: icinga::client::checks
#
# This class provides the default checks for a client machine.
#
# === Parameters:
# [*disk_space_warn*]
#   A warning is triggered when free disk space falls below this
#   percentage.
#
# [*disk_space_critical*]
#   A critical is triggered when free disk space falls below this
#   percentage.
#
#
class icinga::client::checks (
  $disk_space_warn = 20,
  $disk_space_critical = 10,
) {

  include icinga::client::check_file_not_exists
  include icinga::client::check_linux_free_memory
  include icinga::client::check_upstart_status

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
    check_command       => "check_nrpe!check_disk_space_arg!${disk_space_warn}% ${disk_space_critical}% /",
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

  @@icinga::check { "check_zombies_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_zombie_procs',
    service_description => 'high zombie procs',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(high-zombie-procs),
  }

  $grafana = "grafana.${::aws_environment}.govuk.digital"

  @icinga::nrpe_config { 'check_ssh_local':
    source => 'puppet:///modules/icinga/etc/nagios/nrpe.d/check_ssh_local.cfg',
  }

  @@icinga::check { "check_ssh_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_ssh_local',
    use                 => 'govuk_high_priority',
    service_description => 'unable to ssh',
    host_name           => $::fqdn,
  }

  # In vCloud, disk names begin with sd, whereas in AWS they begin with either
  # xvd or nvm, hence the regex.
  $disk_prefix = '{xvd*,nvm*}'

  @@icinga::check { "check_ntp_time_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_ntp_time',
    service_description => 'ntp drift too high',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(ntp-drift-too-high),
  }
}
