# Class: govuk_rbenv::cleanup
#
# Cleans up unneeded ruby versions from a server.
#
# This must be used with care.  Due to the way the `defined` function works,
# this has to come last in the parse/evaluation order.  This can be achieved by
# including it as the last item in the node definition.
class govuk_rbenv::cleanup {
  include rbenv

  if ! defined(Rbenv::Version['1.9.3-p484']) {
    rbenv::version { '1.9.3-p484':
      ensure => absent,
    }
  }

  if ! defined(Rbenv::Version['2.0.0-p353']) {
    rbenv::version { '2.0.0-p353':
      ensure => absent,
    }
  }
  if ! defined(Rbenv::Alias['2.0.0']) {
    file { "${rbenv::params::rbenv_root}/versions/2.0.0":
      ensure => absent,
    }
  }

  if ! defined(Rbenv::Version['2.1.2']) {
    rbenv::version { '2.1.2':
      ensure => absent,
    }
  }
  if ! defined(Rbenv::Version['2.1.4']) {
    rbenv::version { '2.1.4':
      ensure => absent,
    }
  }
  if ! defined(Rbenv::Version['2.1.5']) {
    rbenv::version { '2.1.5':
      ensure => absent,
    }
  }
  if ! defined(Rbenv::Version['2.1.6']) {
    rbenv::version { '2.1.6':
      ensure => absent,
    }
  }
  if ! defined(Rbenv::Alias['2.1']) {
    file { "${rbenv::params::rbenv_root}/versions/2.1":
      ensure => absent,
    }
  }

  if ! defined(Rbenv::Version['2.2.2']) {
    rbenv::version { '2.2.2':
      ensure => absent,
    }
  }
  if ! defined(Rbenv::Alias['2.2']) {
    file { "${rbenv::params::rbenv_root}/versions/2.2":
      ensure => absent,
    }
  }
}
