# == Class: govuk_jenkins::packages::sops
#
# Installs sops https://github.com/mozilla/sops
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   The hostname of an APT mirror
#
# [*apt_mirror_gpg_key_fingerprint*]
#   The fingerprint of an APT mirror
#
class govuk_jenkins::packages::sops (
  $version = '3.0.2',
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
){

  apt::source { 'sops':
    location     => "http://${apt_mirror_hostname}/sops",
    release      => 'stable',
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  package { 'sops':
    ensure  => $version,
    require => Apt::Source['sops'],
  }

}
