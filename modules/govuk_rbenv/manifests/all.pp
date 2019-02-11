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
  $with_foreman = false,
) {
  include govuk_rbenv

  apt::source { 'rbenv-ruby':
    location     => "http://${apt_mirror_hostname}/rbenv-ruby",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  $ruby_versions = [
    '2.4.4',
    '2.4.5',
    '2.5.1',
    '2.5.3',
    '2.6.1',
  ]

  govuk_rbenv::install_ruby_version { $ruby_versions:
    with_foreman => $with_foreman,
  }

  # These aliases resolve .ruby-version 2.x to an installed Ruby version.
  rbenv::alias { '2.4':
    to_version => '2.4.5',
  }
  rbenv::alias { '2.5':
    to_version => '2.5.3',
  }
  rbenv::alias { '2.6':
    to_version => '2.6.1',
  }
}
