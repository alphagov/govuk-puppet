# == Class: govuk_jenkins::packages::gcloud
#
# Installs Google Cloud SDK and Kubectl
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   The hostname of an APT mirror
#
class govuk_jenkins::packages::gcloud (
  $apt_mirror_hostname = undef,
){

  apt::source { 'google-cloud-sdk-trusty':
    location     => "http://${apt_mirror_hostname}/google-cloud-sdk-trusty",
    release      => 'stable',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  package { ['kubectl', 'google-cloud-sdk']:
    ensure  => 'present',
    require => Apt::Source['google-cloud-sdk-trusty'],
  }

}
