# == Class: govuk_unattended_reboot::repo
#
# Use our own repo for locksmith package
#
class govuk_unattended_reboot::repo {
  apt::source { 'locksmithctl':
    location     => 'http://apt_mirror.cluster/locksmithctl',
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
