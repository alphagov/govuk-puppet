# == Class: mongodb::repository
#
# Manage APT repo for MongoDB.
#
# === Parameters
#
# [*use_mirror*]
#   Whether to use our mirror of the repo.
#   Default: true
#
class mongodb::repository(
  $use_mirror = true,
) {
  validate_bool($use_mirror)
  if $use_mirror {
    apt::source { 'mongodb':
      location     => 'http://apt.production.alphagov.co.uk/mongodb',
      release      => 'dist',
      repos        => '10gen',
      architecture => $::architecture,
      key          => '37E3ACBB',
    }
  } else {
    apt::source { 'mongodb':
      location => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart',
      release  => 'dist',
      repos    => '10gen',
      key      => '7F0CEB10', # Richard Kreuter <richard@10gen.com>
    }
  }
}
