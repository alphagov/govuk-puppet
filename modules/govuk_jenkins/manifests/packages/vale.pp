# == Class: govuk_jenkins::packages::vale
#
# Installs Vale lint
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   The hostname of an APT mirror
#
class govuk_jenkins::packages::vale (
  $version = '0.10.0',
  $apt_mirror_hostname,
){

  apt::source { 'vale':
    location     => "http://${apt_mirror_hostname}/vale",
    release      => 'stable',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  package { 'vale':
    ensure  => $version,
    require => Apt::Source['vale'],
  }

}
