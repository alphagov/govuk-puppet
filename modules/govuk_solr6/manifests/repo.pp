# == Class: govuk_solr6::repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
# [*apt_mirror_gpg_key_fingerprint*]
#   Fingerprint to use for the APT mirror.
#
class govuk_solr6::repo (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  apt::source { 'solr':
    location     => "http://${apt_mirror_hostname}/solr",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    repos        => 'main',
    key          => $apt_mirror_gpg_key_fingerprint,
  }
}
