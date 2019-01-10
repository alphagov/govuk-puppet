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
class govuk_splunk::repos (
  $apt_mirror_hostname,
) {
  apt::source { 'splunk':
    location     => "http://${apt_mirror_hostname}/splunk",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    repos        => 'stable',
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  apt::source { 'govuk-splunk-configurator':
    location     => "http://${apt_mirror_hostname}/govuk-splunk-configurator",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    repos        => 'stable',
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
