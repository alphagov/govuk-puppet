# == Class: govuk_java::repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
class govuk_java::repo (
  $apt_mirror_hostname = undef,
) {
  apt::source { 'openjdk':
    location     => "http://${apt_mirror_hostname}/openjdk",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => 'DA1A4A13543B466853BAF164EB9B1D8886F44E2A';
  }
}
