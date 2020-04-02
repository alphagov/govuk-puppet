# == Class: grafana::repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
# [*apt_mirror_gpg_key_fingerprint*]
#   Fingerprint to use for the APT mirror.
#
class grafana::repo (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  apt::source { 'grafana':
    location     => "http://${apt_mirror_hostname}/grafana",
    release      => 'jessie',
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }
}
