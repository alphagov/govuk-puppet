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
      location     => 'http://apt_mirror.cluster/mongodb',
      release      => 'dist',
      repos        => '10gen',
      architecture => $::architecture,
      key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
    }

    apt::source { 'mongodb3.2':
      location     => 'http://apt_mirror.cluster/mongodb3.2',
      release      => 'trusty-mongodb-org-3.2',
      repos        => 'multiverse',
      architecture => $::architecture,
      key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
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
