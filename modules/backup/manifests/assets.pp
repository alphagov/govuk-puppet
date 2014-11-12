# == Class: backup::assets
#
# Offsite backups for assets. These go directly offsite, rather than an
# intermediary onsite backup, because of their size.
#
# === Parameters
#
# [*target*]
#   Destination target prefix for backed-up data. Will append individual
#   back-up directories to this.
#
# [*pubkey_id*]
#   Fingerprint of the public GPG key used for encrypting the back-ups
#   against
#
# [*backup_private_key*]
#   Private key of the off-site backup box. Used in the deployment repo,
#   drawn in here
#
# [*dest_host*]
#   Back-up target's hostname
#
# [*dest_host_key*]
#   SSH hostkey for $dest_host
#
# [*archive_directory*]
#   Place to store the Duplicity cache - the default is ~/.cache/duplicity
#
class backup::assets(
  $target,
  $pubkey_id,
  $backup_private_key,
  $dest_host,
  $dest_host_key,
  $archive_directory = unset,
) {

  file { '/root/.ssh' :
    ensure => directory,
    mode   => '0700',
  }

  file { '/root/.ssh/id_rsa':
    ensure  => present,
    mode    => '0600',
    content => $backup_private_key,
  }

  sshkey { $dest_host :
    ensure => present,
    type   => 'ssh-rsa',
    key    => $dest_host_key
  }

  # FIXME: Remove when deployed.
  backup::offsite::job { 'whitehall':
    ensure      => absent,
    sources     => '',
    destination => '',
    hour        => 0,
    minute      => 0,
    user        => '',
    gpg_key_id  => '',
  }

  backup::offsite::job { 'assets-whitehall':
    sources           => '/mnt/uploads/whitehall',
    destination       => "${target}/whitehall",
    hour              => 4,
    minute            => 20,
    user              => 'root',
    gpg_key_id        => $pubkey_id,
    archive_directory => $archive_directory,
  }

  backup::offsite::job { 'asset-manager':
    sources           => '/mnt/uploads/asset-manager',
    destination       => "${target}/asset-manager",
    hour              => 4,
    minute            => 13,
    user              => 'root',
    gpg_key_id        => $pubkey_id,
    archive_directory => $archive_directory,
  }
}
