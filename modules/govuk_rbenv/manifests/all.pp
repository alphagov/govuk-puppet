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
  $apt_mirror_hostname,
) {
  include govuk_rbenv

  apt::source { 'rbenv-ruby':
    location     => "http://${apt_mirror_hostname}/rbenv-ruby",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  rbenv::version { '2.2.8':
    bundler_version  => '1.16.2',
    install_gem_docs => false,
  }
  rbenv::version { '2.3.1':
    bundler_version  => '1.16.2',
    install_gem_docs => false,
  }
  rbenv::version { '2.3.5':
    bundler_version  => '1.16.2',
    install_gem_docs => false,
  }
  rbenv::version { '2.4.0':
    bundler_version  => '1.16.2',
    install_gem_docs => false,
  }
  rbenv::version { '2.4.2':
    bundler_version  => '1.16.2',
    install_gem_docs => false,
  }
  rbenv::version { '2.4.4':
    bundler_version  => '1.16.2',
    install_gem_docs => false,
  }
  rbenv::version { '2.5.0':
    bundler_version  => '1.16.2',
    install_gem_docs => false,
  }
  rbenv::version { '2.5.1':
    bundler_version  => '1.16.2',
    install_gem_docs => false,
  }

  # These aliases re solve .ruby-version 2.x to an installed Ruby version.
  rbenv::alias { '2.2':
    to_version => '2.2.8',
  }
  rbenv::alias { '2.3':
    to_version => '2.3.5',
  }
  rbenv::alias { '2.4':
    to_version => '2.4.4',
  }
  rbenv::alias { '2.5':
    to_version => '2.5.1',
  }
}
