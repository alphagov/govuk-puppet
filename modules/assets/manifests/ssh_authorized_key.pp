# == Class: assets::ssh_authorized_key
#
# Installs a public key into the assets user's authorized_key file.
#
# === Parameters
#
# [*key*]
#   An authorized SSH key.
#
class assets::ssh_authorized_key (
  $key = undef,
) {
  $username = 'assets'

  file { "/home/${username}/.ssh":
    ensure => directory,
    owner  => $username,
    group  => $username,
    mode   => '0700',
  } ->
  ssh_authorized_key { 'asset-sync':
    user    => 'assets',
    type    => 'ssh-rsa',
    key     => $key,
    require => Class['assets::user'],
  }
}
