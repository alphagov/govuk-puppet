# == Class: puppet::repository
#
# Setup the APT repo for Puppet packages.
#
# === Parameters
#
# [*use_mirror*]
#   Whether to use our own mirror of the PuppetLabs repo. You may want to
#   temporarily disable this if you're bringing up a new production
#   environment.
#   Default: true
#
class puppet::repository(
  $use_mirror = true,
) {
  # This is installed by bootstrapping. `apt::source` takes its place.
  package { 'puppetlabs-release':
    ensure => purged,
  }

  validate_bool($use_mirror)
  if $use_mirror {
    apt::source { 'puppetlabs':
      location     => "http://apt_mirror.cluster/puppetlabs-${::lsbdistcodename}",
      release      => $::lsbdistcodename,
      architecture => $::architecture,
      key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
    }
  } else {
    apt::source {'puppetlabs':
      location => 'http://apt.puppetlabs.com',
      release  => $::lsbdistcodename,
      repos    => 'main dependencies',
      key      => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30', # Puppet Labs Release Key (Puppet Labs Release Key) <info@puppetlabs.com>
    }
  }
}
