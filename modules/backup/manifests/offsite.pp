# == Class: backup::offsite
#
# This class arranges for backups on disk in /data/backups to be encrypted
# with a supplied public key (the private key is not needed) and sent via
# rsync to a destination host. Backups can be retrieved from this
# destination host and decrypted with the private key (which is not stored
# on the destination machine either)
#
# === Parameters
#
# [*enable*]
#   Whether to enable the generation and sending of encrypted backups
#   Default: False
#
# [*src_dirs*]
#   Array of source directories to backup.
#
# [*gpg_key_id*]
#   GPG public key ID to encrypt the backup with.
#
# [*dest_folder*]
#    The folder on the destination machine to send the backups to.
#
# [*dest_host*]
#    Hostname or IP of the machine to send the backups to.
#
# [*dest_host_key*]
#    The SSH key to use to authenticate to the destination machine.
#
class backup::offsite(
  $enable = false,
  $src_dirs,
  $gpg_key_id,
  $dest_folder = '',
  $dest_host,
  $dest_host_key,
) {
  validate_array($src_dirs)
  validate_bool($enable)
  $ensure_backup = $enable ? {
    true    => present,
    default => absent,
  }

  include backup::client

  sshkey { $dest_host:
    ensure => present,
    type   => 'ssh-rsa',
    key    => $dest_host_key,
  }

  # FIXME: Remove when deployed.
  file { '/usr/local/bin/offsite-backup':
    ensure  => absent,
  }

  # FIXME: Remove when deployed.
  cron { 'offsite-backup':
    ensure => absent,
  }

  $threshold_secs = 28 * (60 * 60)
  # Also used in `post_command`
  $service_description = 'offsite backup govuk datastores'

  duplicity { 'offsite-govuk-datastores':
    ensure            => $ensure_backup,
    directory         => $src_dirs,
    target            => "rsync://${dest_host}/${dest_folder}",
    hour              => 8,
    minute            => 13,
    pubkey_id         => $gpg_key_id,
    user              => 'govuk-backup',
    post_command      => template('backup/post_command.sh.erb'),
    remove_older_than => '30D',
  }

  if $enable {
    @@icinga::passive_check { "check_backup_offsite-${::hostname}":
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => $threshold_secs,
    }
  }
}
