# == Class: govuk_unattended_reboot::repo
#
# Use our own repo for locksmith package
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
class govuk_unattended_reboot::repo(
  $apt_mirror_hostname = undef,
) {
  apt::source { 'locksmithctl':
    location     => "http://${apt_mirror_hostname}/locksmithctl",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
