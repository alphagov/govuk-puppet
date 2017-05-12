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
  $private_ssh_key = undef,
  $user = 'logs_processor',
  $enabled = false,
) {
  validate_bool($enabled)

  govuk_user { $user:
    fullname => 'Logs Processor',
  }

  $ensure_dir = $enabled ? {
    true  => 'directory',
    false => 'absent',
  }

  $ensure = $enabled ? {
    true => 'present',
    false => 'absent',
  }

  if $private_ssh_key {
    $ssh_dir = "/home/${user}/.ssh"

    file { $ssh_dir:
      ensure  => $ensure_dir,
      owner   => $user,
      group   => $user,
      mode    => '0644',
      require => Govuk_user[$user],
    }

    file { "${ssh_dir}/id_rsa":
      ensure  => $ensure,
      owner   => $user,
      group   => $user,
      mode    => '0600',
      content => $private_ssh_key,
      require => File[$ssh_dir],
    }
  }

  file { "/home/${user}/.gitconfig":
    ensure  => $ensure,
    owner   => $user,
    group   => $user,
    mode    => '0644',
    source  => 'puppet:///modules/govuk_cdn/logs_processor_gitconfig',
    require => Govuk_user[$user],
  }

  $process_script = '/usr/local/bin/process_transition_logs.sh'

  file { $process_script:
    ensure  => $ensure,
    owner   => $user,
    group   => $user,
    mode    => '0755',
    content => template('govuk_cdnlogs/process_transition_logs.erb'),
  }

  cron::crondotdee { 'process_transition_logs':
    ensure  => $ensure,
    command => $process_script,
    hour    => '*',
    minute  => '30',
    user    => $user,
    require => File[$process_script],
  }

  # Provides /opt/mawk required by pre-transition-stats
  package { 'mawk-1.3.4':
    ensure => installed,
  }
}
