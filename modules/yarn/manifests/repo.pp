# == Class: yarn::repo
#
# Use our own mirror of the yarn repo.
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
# [*apt_mirror_gpg_key_fingerprint*]
#   Fingerprint to use for the APT mirror.
#
class yarn::repo(
  $apt_mirror_hostname = undef,
  $apt_mirror_gpg_key_fingerprint = undef,
) {
  apt::source { 'yarn':
    location     => "http://${apt_mirror_hostname}/yarn",
    release      => 'stable',
    architecture => $::architecture,
    repos        => 'main',
    key          => $apt_mirror_gpg_key_fingerprint,
  }
}
