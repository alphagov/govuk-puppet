# == Class: backup::assets
#
# Offsite backups for assets. These go directly offsite, rather than an
# intermediary onsite backup, because of their size.
#
# === Parameters
# [*backup_private_gpg_key*]
#   GPG private key needed to decrypt offsite backups
#
# [*backup_private_gpg_key_fingerprint*]
#   GPG private key fingerprint
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
# [*jobs*]
#   Hash of `backup::offsite::job` resources. `ensure` parameter will be
#   added.
#
# [*archive_directory*]
#   Place to store the Duplicity cache - the default is ~/.cache/duplicity
#
class backup::assets(
  $backup_private_gpg_key = undef,
  $backup_private_gpg_key_fingerprint = undef,
  $backup_private_key,
  $dest_host,
  $dest_host_key,
  $jobs,
  $archive_directory,
) {
  validate_hash($jobs)

  include backup::repo

  file { '/root/.ssh' :
    ensure => directory,
    mode   => '0700',
  }

  file { '/root/.ssh/id_rsa':
    ensure  => present,
    mode    => '0600',
    content => $backup_private_key,
  }

  if $backup_private_gpg_key and $backup_private_gpg_key_fingerprint {
    validate_re($backup_private_gpg_key_fingerprint, '^[[:alnum:]]{40}$', 'Must supply full GPG fingerprint')

    file { '/root/.gnupg':
      ensure => directory,
      mode   => '0700',
    }

    file { "/root/.gnupg/${backup_private_gpg_key_fingerprint}_secret_key.asc":
      ensure  => present,
      mode    => '0600',
      content => $backup_private_gpg_key,
    }

    exec { "import_gpg_secret_key_${::hostname}":
      command     => "gpg --batch --delete-secret-and-public-key ${backup_private_gpg_key_fingerprint}; gpg --allow-secret-key-import --import /root/.gnupg/${backup_private_gpg_key_fingerprint}_secret_key.asc",
      user        => 'root',
      group       => 'root',
      subscribe   => File["/root/.gnupg/${backup_private_gpg_key_fingerprint}_secret_key.asc"],
      refreshonly => true,
    }
  }

  sshkey { $dest_host :
    ensure => present,
    type   => 'ssh-rsa',
    key    => $dest_host_key,
  }

  create_resources('backup::offsite::job', $jobs, {
    'archive_directory' => $archive_directory,
  })
}
