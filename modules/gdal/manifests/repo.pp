# == Class: gdal::repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
class gdal::repo (
  $apt_mirror_hostname,
) {
  apt::source { 'gdal':
    location     => "http://${apt_mirror_hostname}/gdal",
    release      => 'stable',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
