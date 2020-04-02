# == Class: govuk_jenkins::packages::terraform
#
# Installs Terraform https://www.terraform.io/
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   The hostname of an APT mirror
#
# [*apt_mirror_gpg_key_fingerprint*]
#   The fingerprint of an APT mirror
#
class govuk_jenkins::packages::terraform (
  $version = '0.11.14',
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
){

  apt::source { 'terraform':
    location     => "http://${apt_mirror_hostname}/terraform",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  package { 'terraform':
    ensure  => $version,
    require => Apt::Source['terraform'],
  }

}
