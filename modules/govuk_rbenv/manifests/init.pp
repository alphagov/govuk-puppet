# Class: govuk_rbenv
#
# Installs rbenv and some rubies.
#
# === Parameters
#
# [*rubies*]
#   A string specifying which set of rubies should be installed. The basic
#   set of rubies are ones that are needed on all machines, eg to run Puppet.
#   The set of all rubies includes rubies required to run applications.
#
class govuk_rbenv (
  $rubies = 'basic',
) {
  validate_re($rubies, '^(basic|all)$', 'Set of rubies must be either "basic" or "all"')

  include rbenv

  rbenv::version { '1.9.3-p550':
    bundler_version => '1.7.4'
  }
  rbenv::alias { '1.9.3':
    to_version => '1.9.3-p550',
  }

  if $rubies == 'all' {
    rbenv::version { '1.9.3-p484':
      bundler_version => '1.6.5'
    }

    rbenv::version { '2.1.2':
      bundler_version => '1.6.5'
    }
    rbenv::version { '2.1.4':
      bundler_version => '1.7.4'
    }
    rbenv::version { '2.1.5':
      bundler_version => '1.8.3'
    }
    rbenv::version { '2.1.6':
      bundler_version => '1.9.4',
    }
    rbenv::version { '2.1.7':
      bundler_version => '1.10.6',
    }
    rbenv::alias { '2.1':
      to_version => '2.1.7'
    }

    rbenv::version { '2.2.2':
      bundler_version => '1.9.4',
    }
    rbenv::version { '2.2.3':
      bundler_version => '1.10.6',
    }
    rbenv::alias { '2.2':
      to_version => '2.2.3'
    }
  }
}
