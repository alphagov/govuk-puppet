# == Class: Govuk_postgresql::Mirror
#
# Add the apt source for the PostgreSQL aptly mirror
#
class govuk_postgresql::mirror (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  if $::lsbdistcodename == 'trusty' {
    apt::source { 'postgresql':
      location     => "http://${apt_mirror_hostname}/postgresql",
      release      => "${::lsbdistcodename}-pgdg",
      architecture => $::architecture,
      key          => $apt_mirror_gpg_key_fingerprint,
    }
  }
}
