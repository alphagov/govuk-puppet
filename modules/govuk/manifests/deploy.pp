class govuk::deploy {
  include bundler
  include govuk::logging
  include govuk::python
  include harden
  include unicornherder

  anchor { 'govuk::deploy::begin': }

  # These resources are required, but should not refresh apps.
  class { 'govuk::deploy::setup':
    require => Anchor['govuk::deploy::begin'],
  }

  # These resources should refresh apps.
  class { 'govuk::deploy::config':
    require => Class['govuk::deploy::setup'],
  }

  anchor { 'govuk::deploy::end':
    subscribe => Class['govuk::deploy::config'],
    require   => Class['unicornherder'],
  }
}
