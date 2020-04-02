# == Class: govuk_docker::repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
# [*apt_mirror_gpg_key_fingerprint*]
#   Fingerprint to use for the APT mirror.
#
class govuk_docker::repo (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  apt::source { 'docker':
    location     => "http://${apt_mirror_hostname}/docker",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    repos        => 'stable',
    key          => $apt_mirror_gpg_key_fingerprint,
  }
}
