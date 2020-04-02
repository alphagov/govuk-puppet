# == Class: govuk_rabbitmq::repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
# [*apt_mirror_gpg_key_fingerprint*]
#   Fingerprint to use for the APT mirror.
#
class govuk_rabbitmq::repo (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  apt::source { 'rabbitmq':
    location     => "http://${apt_mirror_hostname}/rabbitmq",
    release      => 'testing',
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }
}
