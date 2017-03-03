# == Class: govuk_jenkins::packages::terraform
#
# Installs Terraform https://www.terraform.io/
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   The hostname of an APT mirror
#
class govuk_jenkins::packages::terraform (
  $apt_mirror_hostname = undef,
){

  apt::source { 'terraform':
    location     => "http://${apt_mirror_hostname}/terraform",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  package { 'terraform':
    ensure  => '0.8.1',
    require => Apt::Source['terraform'],
  }

}
