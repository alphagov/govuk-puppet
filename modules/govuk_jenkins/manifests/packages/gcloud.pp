# == Class: govuk_jenkins::packages::gcloud
#
# Installs Google Cloud SDK and Kubectl
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   The hostname of an APT mirror
#
# [*apt_mirror_gpg_key_fingerprint*]
#   The fingerprint of an APT mirror
#
class govuk_jenkins::packages::gcloud (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
){

  apt::source { 'google-cloud-sdk-trusty':
    location     => "http://${apt_mirror_hostname}/google-cloud-sdk-trusty",
    release      => 'stable',
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  package { ['kubectl', 'google-cloud-sdk']:
    ensure  => 'present',
    require => Apt::Source['google-cloud-sdk-trusty'],
  }

}
