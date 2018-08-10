# == Class: govuk_env_sync::sync_script
#
# Install the sync script
#
class govuk_env_sync::sync_script {

  # sync script
  file { '/usr/local/bin/govuk_env_sync.sh':
    ensure => present,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/govuk_env_sync/govuk_env_sync.sh',
  }

}
