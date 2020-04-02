# == Class: Backup::Repo
#
# Add the local mirror apt source for duplicity
#
# === Parameters:
#
#  [*apt_mirror_hostname*]
#    The hostname of the local aptly mirror.
#
#  [*apt_mirror_gpg_key_fingerprint*]
#    The fingerprint of the local aptly mirror.
#
class backup::repo (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  apt::source { 'duplicity':
    location     => "http://${apt_mirror_hostname}/duplicity",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }
}
