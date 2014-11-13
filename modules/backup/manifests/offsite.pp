# == Class: backup::offsite
#
# Transfer onsite backups to an offsite machine. Some are encrypted against
# a public GPG key, for which the private key to retrieve them can be found
# in the creds store.
#
# === Parameters
#
# [*enable*]
#   Whether to enable the generation and sending of encrypted backups
#   Default: False
#
# [*datastores_srcdirs*]
#   Array of source directories for datastore backups.
#
# [*graphite_srcdir*]
#   String of ource directory for Graphite backups.
#
# [*gpg_key_id*]
#   GPG public key ID to encrypt the backup with.
#
# [*datastores_destdir*]
#   Destination directory for datastore backups.
#
# [*graphite_destdir*]
#   Destination directory for Graphite backups.
#
# [*dest_host*]
#    Hostname or IP of the machine to send the backups to.
#
# [*dest_host_key*]
#    The SSH key to use to authenticate to the destination machine.
#
class backup::offsite(
  $enable = false,
  $datastores_srcdirs,
  $graphite_srcdir,
  $gpg_key_id,
  $datastores_destdir,
  $graphite_destdir,
  $dest_host,
  $dest_host_key,
) {
  validate_array($datastores_srcdirs)
  validate_string($graphite_srcdir, $datastores_destdir, $graphite_destdir)
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
  backup::offsite::job { 'offsite-govuk-datastores':
    ensure      => absent,
    sources     => '',
    destination => '',
    hour        => 0,
    minute      => 0,
    user        => '',
    gpg_key_id  => '',
  }

  backup::offsite::job { 'govuk-datastores':
    ensure      => $ensure_backup,
    sources     => $datastores_srcdirs,
    destination => "rsync://${dest_host}/${datastores_destdir}",
    hour        => 8,
    minute      => 13,
    gpg_key_id  => $gpg_key_id,
  }

  backup::offsite::job { 'govuk-graphite':
    ensure      => $ensure_backup,
    sources     => $graphite_srcdir,
    destination => "rsync://${dest_host}/${graphite_destdir}",
    hour        => 8,
    minute      => 13,
    # No encryption because of size and sensitivity
  }
}
