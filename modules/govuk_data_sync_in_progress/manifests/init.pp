# == Class: govuk_data_sync_in_progress
#
# Configure the `data_sync_in_progress` fact and optionally allows commands
# to run when the data sync starts and finishes.
#
# === Parameters
#
# [*start_command*]
#   Command to run when the data sync starts.
#
# [*finish_command*]
#   Command to run when the data sync finishes.
#
define govuk_data_sync_in_progress(
  $start_command = undef,
  $finish_command = undef
) {
  $fact_path = '/etc/govuk/env.d/FACTER_data_sync_in_progress'

  $start_hour = 22
  $start_minute = 0

  $finish_hour = 5
  $finish_minute = 45

  if !defined(File[$fact_path]) {
    file { $fact_path:
      ensure  => present,
      owner   => 'deploy',
      require => Class['govuk::deploy'],
    }
  }

  if !defined(Cron['data_sync_started']) {
    cron { 'data_sync_started':
      command => "echo 'true' > ${fact_path}",
      user    => 'deploy',
      hour    => $start_hour,
      minute  => $start_minute,
    }
  }

  if !defined(Cron['data_sync_finished']) {
    cron { 'data_sync_finished':
      command => "echo '' > ${$fact_path}",
      user    => 'deploy',
      hour    => $finish_hour,
      minute  => $finish_minute,
    }
  }

  if $start_command {
    cron { "data_sync_started_${title}":
      command => $start_command,
      user    => 'deploy',
      hour    => $start_hour,
      minute  => $start_minute,
    }
  }

  if $finish_command {
    cron { "data_sync_finished_${title}":
      command => $finish_command,
      user    => 'deploy',
      hour    => $finish_hour,
      minute  => $finish_minute,
    }
  }
}
