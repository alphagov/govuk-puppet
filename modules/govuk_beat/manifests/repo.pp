# == Class: govuk_beat::repo
#
# Use our own mirror of the beat repo. Should be used with `manage_repo`
# disable of the upstream module.
#
class govuk_beat::repo {
  apt::source { 'elastic-beats':
    location     => 'http://apt_mirror.cluster/elastic-beats',
    release      => 'stable',
    architecture => $::architecture,
    key          => '',
  }
}
