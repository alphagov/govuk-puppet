# Class: govuk_rbenv::all
#
# Installs rbenv and the full set of rubies.  This is provides the set of
# rubies that are needed to run our ruby apps.
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   Hostname of the APT mirror to install packages from
#
class govuk_rbenv::all (
  $apt_mirror_hostname = undef,
) {
  include govuk_rbenv

  apt::source { 'rbenv-ruby':
    location     => "http://${apt_mirror_hostname}/rbenv-ruby",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
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
  rbenv::version { '2.3.1':
    bundler_version => '1.11.2',
  }
  rbenv::alias { '2.3':
    to_version => '2.3.1',
  }

  rbenv::version { '2.4.0':
    bundler_version => '1.13.7',
  }
  rbenv::alias { '2.4':
    to_version => '2.4.0',
  }
}
