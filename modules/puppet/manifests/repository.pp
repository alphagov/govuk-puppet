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
      location     => 'http://apt.production.alphagov.co.uk/puppetlabs',
      release      => 'stable',
      architecture => $::architecture,
      key          => '37E3ACBB',
    }
  } else {
    apt::source {'puppetlabs':
      location => 'http://apt.puppetlabs.com',
      release  => 'stable',
      repos    => 'main dependencies',
      key      => '4BD6EC30', # Puppet Labs Release Key (Puppet Labs Release Key) <info@puppetlabs.com>
    }
  }
}
