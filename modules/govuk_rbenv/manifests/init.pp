# Class: govuk_rbenv
#
# Installs rbenv and the base set of rubies.  This is intended to provide the
# rubies that are needed on all machines - mainly to run puppet etc.
#
class govuk_rbenv {
  include rbenv

  rbenv::version { '2.1.8':
    bundler_version => '1.10.6',
  }
  rbenv::alias { '2.1':
    to_version => '2.1.8',
  }

  # FIXME: we're leaving this in for now while we upgrade the puppet used ruby. 
  # We're also unsure if we have any other scripts running.
  rbenv::version { '1.9.3-p550':
    bundler_version => '1.7.4',
  }
  rbenv::alias { '1.9.3':
    to_version => '1.9.3-p550',
  }

}
