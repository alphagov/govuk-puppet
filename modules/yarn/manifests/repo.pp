# == Class: yarn::repo
#
# Use our own mirror of the yarn repo.
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
class yarn::repo(
  $apt_mirror_hostname = undef,
) {
  apt::source { 'yarn':
    location     => "http://${apt_mirror_hostname}/yarn",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    repos        => 'stable',
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
