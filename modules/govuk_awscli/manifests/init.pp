# == Class: govuk_awscli
#
# Installs the Apt repo for the AWS CLI, and installs the AWS CLI from the Apt repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   The hostname of the Apt mirror containing the awscli repo
#
class govuk_awscli (
  $apt_mirror_hostname,
)
{
  apt::source { 'awscli':
    ensure       => present,
    location     => "http://${apt_mirror_hostname}/awscli",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  package { 'awscli':
    ensure  => latest,
    require => Apt::Source['awscli'],
  }
}
