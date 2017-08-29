# == Class: govuk_cdnlogs::transition_logs
#
# Processes transition logs and pushes them to git repositories to be used
# by the transition app
#
# === Parameters:
#
# [*log_dir*]
#   Where the CDN logs are stored.
#
# [*private_ssh_key*]
#   The private SSH key used to authenticate with Github. The public part of
#   the key should be added to the Github repositories.
#
# [*user*]
#   The user that processes the logs and pushes them to Github.
#
# [*enabled*]
#   Enable this only in environments that require running the job.
#
class govuk_cdnlogs::transition_logs (
  $log_dir,
  $transition_stats_private_ssh_key = undef,
  $pre_transition_stats_private_ssh_key = undef,
  $user = 'logs_processor',
  $enabled = true,
  $enable_cron = false,
  $alert_hostname = 'alert.cluster',
) {
  validate_bool($enabled)

  $ensure_dir = $enabled ? {
    true  => 'directory',
    false => 'absent',
  }

  $ensure = $enabled ? {
    true => 'present',
    false => 'absent',
  }

  govuk_user { $user:
    ensure   => $ensure,
    fullname => 'Logs Processor',
  }


  if $transition_stats_private_ssh_key and $pre_transition_stats_private_ssh_key {
    $ssh_dir = "/home/${user}/.ssh"

    file { "${ssh_dir}/transition_stats_rsa":
      ensure  => $ensure,
      owner   => $user,
      group   => $user,
      mode    => '0600',
      content => $transition_stats_private_ssh_key,
      require => File[$ssh_dir],
    }

    file { "${ssh_dir}/pre_transition_stats_rsa":
      ensure  => $ensure,
      owner   => $user,
      group   => $user,
      mode    => '0600',
      content => $pre_transition_stats_private_ssh_key,
      require => File[$ssh_dir],
    }

    file {"${ssh_dir}/config":
        ensure  => $ensure,
        owner   => $user,
        group   => $user,
        mode    => '0644',
        source  => 'puppet:///modules/govuk_cdnlogs/logs_processor_ssh_config',
        require => Govuk_user[$user],
    }
  }

  file { "/home/${user}/.gitconfig":
    ensure  => $ensure,
    owner   => $user,
    group   => $user,
    mode    => '0644',
    source  => 'puppet:///modules/govuk_cdnlogs/logs_processor_gitconfig',
    require => Govuk_user[$user],
  }

  file { "${log_dir}/config.yml":
    ensure => $ensure,
    owner  => $user,
    group  => $user,
    source => 'puppet:///modules/govuk_cdnlogs/logs_processor_config',
  }

  # The transition logs processing script creates a cache of processed logs
  file { ["${log_dir}/cache", "${log_dir}/cache/archive"]:
    ensure => $ensure_dir,
    owner  => $user,
    group  => $user,
  }

  file { '/etc/logrotate.d/transition_logs_cache':
    ensure  => $ensure,
    content => template('govuk_cdnlogs/etc/logrotate.d/transition_logs_cache.erb'),
    require => File["${log_dir}/cache"],
  }

  $process_script = '/usr/local/bin/process_transition_logs'

  # FIXME: remove when deployed to Production
  file { '/usr/local/bin/process_transition_logs.sh':
    ensure => 'absent',
  }

  $service_desc = 'Transition logs processing script'

  file { $process_script:
    ensure  => $ensure,
    owner   => $user,
    group   => $user,
    mode    => '0755',
    content => template('govuk_cdnlogs/process_transition_logs.erb'),
  }

  if $enable_cron {
    cron::crondotdee { 'process_transition_logs':
      ensure  => $ensure,
      command => $process_script,
      hour    => '*',
      minute  => '30',
      user    => $user,
      path    => '/usr/lib/rbenv/shims:/usr/sbin:/usr/bin:/sbin:/bin',
      require => File[$process_script],
    }

    @@icinga::passive_check { "transition-logs-processing-script-${::hostname}":
      service_description => $service_desc,
      host_name           => $::fqdn,
      freshness_threshold => 3600,
      notes_url           => monitoring_docs_url(data-sources-for-transition),
    }
  }

  # Provides /opt/mawk required by pre-transition-stats
  package { 'mawk-1.3.4':
    ensure => installed,
  }
}
