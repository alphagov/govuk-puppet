# == Class: govuk_prometheus_node_exporter::repo
#
# Installs the following Deb package:
# prometheus node exporter: 
# which makes its possible for the prometheus server to pull metrics from a host
#
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
class govuk_prometheus_node_exporter::repo (
  $apt_mirror_hostname,
) {
  apt::source { 'govuk-prometheus-node-exporter':
    location     => "http://${apt_mirror_hostname}/govuk-prometheus-node-exporter",
    release      => 'stable',
    architecture => $::architecture,
    repos        => 'main',
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
