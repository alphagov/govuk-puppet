# == Class: backup::assets
#
# Offsite backups for assets. These go directly offsite, rather than an
# intermediary onsite backup, because of their size.
#
# === Parameters
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
  $backup_private_key,
  $dest_host,
  $dest_host_key,
  $jobs,
  $archive_directory,
) {
  validate_hash($jobs)

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

  create_resources('backup::offsite::job', $jobs, {
    'archive_directory' => $archive_directory,
  })
}
