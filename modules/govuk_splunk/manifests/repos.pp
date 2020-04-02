# == Class: govuk_splunk::repos
#
# Installs the following Debian packages:
# 1. the Splunk universal forwarder: which collects and forwards the logs to
#    the Splunk cloud
# 2. the GDS Splunk configurator: which configures the Splunk forwarder
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
class govuk_splunk::repos (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  apt::source { 'splunk':
    location     => "http://${apt_mirror_hostname}/splunk",
    release      => 'stable',
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  apt::source { 'govuk-splunk-configurator':
    location     => "http://${apt_mirror_hostname}/govuk-splunk-configurator",
    release      => 'stable',
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }
}
