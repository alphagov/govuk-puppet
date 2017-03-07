# == Class: Backup::Repo
#
# Add the local mirror apt source for duplicity
#
# === Parameters:
#
#  [*apt_mirror_hostname*]
#    The hostname of the local aptly mirror.
#
class backup::repo (
  $apt_mirror_hostname = undef,
) {
  apt::source { 'duplicity':
    location     => "http://${apt_mirror_hostname}/duplicity",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
