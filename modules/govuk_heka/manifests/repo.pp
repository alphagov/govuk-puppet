# == Class: govuk_heka::repo
#
# Setup our "mirror" of the Heka repo.
#
class govuk_heka::repo {
  apt::source { 'heka':
    location     => 'http://apt.production.alphagov.co.uk/heka',
    release      => 'binary',
    architecture => $::architecture,
    key          => '37E3ACBB',
    before       => Class['heka'],
  }
}
