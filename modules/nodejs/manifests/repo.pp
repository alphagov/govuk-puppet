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
class nodejs::repo(
  $apt_mirror_hostname,
) {
  apt::source { 'nodejs':
    location     => "http://${apt_mirror_hostname}/nodejs",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
