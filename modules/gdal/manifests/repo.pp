# == Class: gdal::repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
# [*apt_mirror_gpg_key_fingerprint*]
#   Fingerprint to use for the APT mirror.
#
class gdal::repo (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  apt::source { 'gdal':
    location     => "http://${apt_mirror_hostname}/gdal",
    release      => 'stable',
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }
}
