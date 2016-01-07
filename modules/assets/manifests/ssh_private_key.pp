# == Class: assets::ssh_private_key
#
# Installs a private key for the `assets` user
#
# === Parameters
#
# [*key*]
#   A private SSH key.
#
class assets::ssh_private_key (
  $key = undef,
) {
  $username = 'assets'
  $ssh_dir = "/home/${username}/.ssh"

  file { $ssh_dir:
    ensure => directory,
    owner  => $username,
    group  => $username,
    mode   => '0700',
  } ->
  file { "${ssh_dir}/id_rsa":
    ensure  => file,
    owner   => $username,
    mode    => '0600',
    content => $key,
    require => Class['assets::user'],
  }
}
