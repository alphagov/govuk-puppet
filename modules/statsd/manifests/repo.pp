# == Class: statsd::repo
#
# Use our own Statsd repo
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
# [*apt_mirror_gpg_key_fingerprint*]
#   Fingerprint to use for the APT mirror.
#
class statsd::repo(
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  apt::source { 'statsd':
    location     => "http://${apt_mirror_hostname}/statsd",
    release      => 'stable',
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }
}
