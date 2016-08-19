# == Class: Govuk_postgresql::Mirror
#
# Add the apt source for the PostgreSQL aptly mirror
#
class govuk_postgresql::mirror (
  $apt_mirror_hostname = undef,
) {
  apt::source { 'postgresql':
    location     => "http://${apt_mirror_hostname}/postgresql",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
