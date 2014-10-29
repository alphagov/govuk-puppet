# == backup::assets
#
#    This class backs up assets from Whitehall and asset-manager
#    using the Duplicity module.
#
# == Parameters
#
#    $target
#      Destination target prefix for backed-up data. Will append individual
#      back-up directories to this.
#
#    $pubkey_id
#      Fingerprint of the public GPG key used for encrypting the back-ups
#      against
#
#    $backup_private_key
#      Private key of the off-site backup box. Used in the deployment repo,
#      drawn in here
#
#    $dest_host
#      Back-up target's hostname
#
#    $dest_host_key
#      SSH hostkey for $dest_host
#
#    $archive_directory
#      Place to store the Duplicity cache - the default is ~/.cache/duplicity
#
class backup::assets(
  $target,
  $pubkey_id,
  $backup_private_key,
  $dest_host,
  $dest_host_key,
  $archive_directory = unset,
) {

  $sshkey_file = '/root/.ssh/id_rsa'

  file { '/root/.ssh' :
    ensure => directory,
    mode   => '0700',
  }

  file { $sshkey_file :
    ensure  => present,
    mode    => '0600',
    content => $backup_private_key,
  }

  sshkey { $dest_host :
    ensure => present,
    type   => 'ssh-rsa',
    key    => $dest_host_key
  }

  exec { 'assets-gpgkey':
    command => "gpg -q --recv-keys ${::gpgkey}",
    unless  => "gpg -q --list-keys ${::gpgkey}"
  }

  backup::assets::job { 'whitehall':
    asset_path        => '/mnt/uploads/whitehall',
    target            => "${target}/whitehall",
    hour              => 4,
    minute            => 20,
    pubkey_id         => $pubkey_id,
    ssh_id            => $sshkey_file,
    archive_directory => $archive_directory,
  }

  backup::assets::job { 'asset-manager':
    asset_path        => '/mnt/uploads/asset-manager',
    target            => "${target}/asset-manager",
    hour              => 4,
    minute            => 13,
    pubkey_id         => $pubkey_id,
    ssh_id            => $sshkey_file,
    archive_directory => $archive_directory,
  }
}
