# == Class: mongodb::repository
#
# Manage APT repo for MongoDB.
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#   Defaults to undefined because `$use_mirror` can be disabled.
#
# [*apt_mirror_gpg_key_fingerprint*]
#   Fingerprint to use for the APT mirror.
#   Defaults to undefined because `$use_mirror` can be disabled.
#
# [*use_mirror*]
#   Whether to use our mirror of the repo.
#   Default: true
#
class mongodb::repository(
  $use_mirror = true,
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  validate_bool($use_mirror)
  if $use_mirror {
    apt::source { 'mongodb':
      location     => "http://${apt_mirror_hostname}/mongodb",
      release      => 'dist',
      repos        => '10gen',
      architecture => $::architecture,
      key          => $apt_mirror_gpg_key_fingerprint,
    }

    apt::source { 'govuk-mongo':
      location     => "http://${apt_mirror_hostname}/govuk-mongo",
      release      => 'stable',
      repos        => 'main',
      architecture => $::architecture,
      key          => $apt_mirror_gpg_key_fingerprint,
    }

    apt::source { 'mongodb3.2':
      location     => "http://${apt_mirror_hostname}/mongodb3.2",
      release      => 'trusty-mongodb-org-3.2',
      repos        => 'multiverse',
      architecture => $::architecture,
      key          => $apt_mirror_gpg_key_fingerprint,
    }

  } else {
    apt::source { 'mongodb':
      location => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart',
      release  => 'dist',
      repos    => '10gen',
      key      => '492EAFE8CD016A07919F1D2B9ECBEC467F0CEB10', # Richard Kreuter <richard@10gen.com>
    }
  }
}
