# == Class: govuk_env_sync::log
#
# Create a log file and ensure rotation
#
class govuk_env_sync::log {
  #
  # Log dir
  #
  file { '/var/log/govuk_env_sync':
    ensure => 'directory',
    owner  => $govuk_env_sync::user,
    group  => $govuk_env_sync::user,
    mode   => '0644',
  }

  @logrotate::conf { 'govuk_env_sync':
    ensure        => 'present',
    matches       => '/var/log/govuk_env_sync/govuk_env_sync.log',
    days_to_keep  => '7',
    delaycompress => true,
    copytruncate  => false,
    create        => "644 ${govuk_env_sync::user} ${govuk_env_sync::user}",
  }

}
