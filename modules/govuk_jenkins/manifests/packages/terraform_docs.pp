# == Class: govuk_jenkins::packages::terraform_docs
#
# Installs terraform-docs
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   The hostname of an APT mirror
#
class govuk_jenkins::packages::terraform_docs (
  $apt_mirror_hostname,
  $version = '0.3.0',
){

  apt::source { 'terraform-docs':
    location     => "http://${apt_mirror_hostname}/terraform-docs",
    release      => 'stable',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  package { 'terraform-docs':
    ensure  => absent,
  }

}
