# == Class: govuk_env_sync::lock_file
#
# Set permissions on the lock file
#
class govuk_env_sync::lock_file {
  #
  # Lock file
  #
  file { '/etc/unattended-reboot/no-reboot/govuk_env_sync':
    mode  => '0660',
    owner => $govuk_env_sync::user,
    group => $govuk_env_sync::user,
  }
}
