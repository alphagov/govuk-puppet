# == Class: govuk_unattended_reboot::repo
#
# Use our own repo for locksmith package
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
# [*apt_mirror_gpg_key_fingerprint*]
#   Fingerprint to use for the APT mirror.
#
class govuk_unattended_reboot::repo(
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  apt::source { 'locksmithctl':
    location     => "http://${apt_mirror_hostname}/locksmithctl",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }
}
