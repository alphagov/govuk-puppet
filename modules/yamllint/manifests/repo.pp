# == Class: yamllint::repo
#
# Use our own mirror of the yamllint repo.
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
# [*apt_mirror_gpg_key_fingerprint*]
#   Fingerprint to use for the APT mirror.
#
class yamllint::repo(
  $apt_mirror_hostname = undef,
  $apt_mirror_gpg_key_fingerprint = undef,
) {
  apt::source { 'yamllint':
    location     => "http://${apt_mirror_hostname}/yamllint",
    release      => 'stable',
    architecture => $::architecture,
    repos        => 'main',
    key          => $apt_mirror_gpg_key_fingerprint,
  }
}
