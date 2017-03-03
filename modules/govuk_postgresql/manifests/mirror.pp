# == Class: Govuk_postgresql::Mirror
#
# Add the apt source for the PostgreSQL aptly mirror
#
class govuk_postgresql::mirror {
  if $::lsbdistcodename == 'trusty' {
    apt::source { 'postgresql':
      location     => 'http://apt_mirror.cluster/postgresql',
      release      => "${::lsbdistcodename}-pgdg",
      architecture => $::architecture,
      key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
    }
  }
}
