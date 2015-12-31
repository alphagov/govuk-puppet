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

  file { "/home/${username}/.ssh/id_rsa":
    ensure  => file,
    owner   => $username,
    mode    => '0600',
    content => $key,
    require => Class['assets::user'],
  }
}
