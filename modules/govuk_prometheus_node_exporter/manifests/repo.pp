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
# [*apt_mirror_gpg_key_fingerprint*]
#   Fingerprint to use for the APT mirror.
#
class govuk_prometheus_node_exporter::repo (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  apt::source { 'govuk-prometheus-node-exporter':
    location     => "http://${apt_mirror_hostname}/govuk-prometheus-node-exporter",
    release      => 'stable',
    architecture => $::architecture,
    repos        => 'main',
    key          => $apt_mirror_gpg_key_fingerprint,
  }
}
