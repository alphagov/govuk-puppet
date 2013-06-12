class govuk::deploy {
  include bundler
  include fpm
  include govuk::logging
  include harden
  include pip
  include python
  include virtualenv
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
