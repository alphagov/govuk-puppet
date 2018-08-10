# == Class: govuk_docker::repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
class govuk_docker::repo (
  $apt_mirror_hostname,
) {
  apt::source { 'docker':
    location     => "http://${apt_mirror_hostname}/docker",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    repos        => 'stable',
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
