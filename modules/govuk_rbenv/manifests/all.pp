# Class: govuk_rbenv::all
#
# Installs rbenv and the full set of rubies.  This is provides the set of
# rubies that are needed to run our ruby apps.
#
class govuk_rbenv::all {
  include govuk_rbenv

  rbenv::version { '1.9.3-p484':
    bundler_version => '1.6.5'
  }

  rbenv::version { '2.0.0-p353':
    bundler_version => '1.6.5'
  }
  rbenv::version { '2.0.0-p451':
    bundler_version => '1.6.5'
  }
  rbenv::version { '2.0.0-p594':
    bundler_version => '1.7.4'
  }
  rbenv::alias { '2.0.0':
    to_version => '2.0.0-p594',
  }

  rbenv::version { '2.1.2':
    bundler_version => '1.6.5'
  }
  rbenv::version { '2.1.4':
    bundler_version => '1.7.4'
  }
  rbenv::alias { '2.1':
    to_version => '2.1.4'
  }
}
