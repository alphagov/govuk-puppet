# == Class: govuk_awscli
#
# Installs the Apt repo for the AWS CLI, and installs the AWS CLI from the Apt repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   The hostname of the Apt mirror containing the awscli repo
#
# [*apt_mirror_gpg_key_fingerprint*]
#   The fingerprint of the Apt mirror containing the awscli repo
#
class govuk_awscli (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
)
{
  apt::source { 'awscli':
    ensure       => present,
    location     => "http://${apt_mirror_hostname}/awscli",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  package { 'awscli':
    ensure  => latest,
    require => Apt::Source['awscli'],
  }
}
