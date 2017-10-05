# == Class: govuk_beat::repo
#
# Use our own mirror of the beat repo. Should be used with `manage_repo`
# disable of the upstream module.
#
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
class govuk_beat::repo(
  $apt_mirror_hostname = undef,
) {
  apt::source { 'elastic-beats':
    location     => "http://${apt_mirror_hostname}/elastic-beats",
    release      => 'stable',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
