# Class: govuk_rbenv::all
#
# Installs rbenv and the full set of rubies.  This is provides the set of
# rubies that are needed to run our ruby apps.
#
class govuk_rbenv::all {
  include govuk_rbenv

  rbenv::version { '1.9.3-p484':
    ensure => absent, # FIXME: Remove this resource once purged everywhere
  }

  rbenv::version { '2.1.2':
    bundler_version => '1.6.5',
  }
  rbenv::version { '2.1.4':
    bundler_version => '1.7.4',
  }
  rbenv::version { '2.1.5':
    bundler_version => '1.8.3',
  }
  rbenv::version { '2.1.6':
    bundler_version => '1.9.4',
  }
  rbenv::version { '2.1.7':
    bundler_version => '1.10.6',
  }
  rbenv::version { '2.1.8':
    bundler_version => '1.10.6',
  }
  rbenv::alias { '2.1':
    to_version => '2.1.8',
  }

  rbenv::version { '2.2.2':
    bundler_version => '1.9.4',
  }
  rbenv::version { '2.2.3':
    bundler_version => '1.10.6',
  }
  rbenv::version { '2.2.4':
    bundler_version => '1.10.6',
  }
  rbenv::alias { '2.2':
    to_version => '2.2.4',
  }

  rbenv::version { '2.3.0':
    bundler_version => '1.11.2',
  }
  rbenv::alias { '2.3':
    to_version => '2.3.0',
  }
}
