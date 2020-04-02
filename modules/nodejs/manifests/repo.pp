# == Class: nodejs::repo
#
# Use our own mirror of the nodejs repo. Should be used with `manage_repo`
# disable of the upstream module.
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
# [*apt_mirror_gpg_key_fingerprint*]
#   Fingerprint to use for the APT mirror.
#
class nodejs::repo(
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  apt::source { 'nodejs':
    location     => "http://${apt_mirror_hostname}/nodejs",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }
}
