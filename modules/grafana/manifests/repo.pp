# == Class: grafana::repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
class grafana::repo (
  $apt_mirror_hostname,
) {
  apt::source { 'grafana':
    location     => "http://${apt_mirror_hostname}/grafana",
    release      => 'main',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
