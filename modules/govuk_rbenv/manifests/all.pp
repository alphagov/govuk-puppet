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
# [*apt_mirror_gpg_key_fingerprint*]
#   Fingerprint of the APT mirror to install packages from
#
class govuk_rbenv::all (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
  $with_foreman = false,
) {
  include govuk_rbenv

  apt::source { 'rbenv-ruby':
    location     => "http://${apt_mirror_hostname}/rbenv-ruby",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  $ruby_versions = [
    '2.6.3',
    '2.6.5',
    '2.6.6',
    '2.6.9',
    '2.7.0',
    '2.7.1',
    '2.7.2',
    '2.7.3',
    '2.7.5',
    '2.7.6',
    '3.0.3',
    '3.0.4',
    '3.0.5',
    '3.1.2',
    '3.2.0',
  ]

  govuk_rbenv::install_ruby_version { $ruby_versions:
    with_foreman => $with_foreman,
  }

  # These aliases resolve .ruby-version 2.x to an installed Ruby version.
  rbenv::alias { '2.6':
    to_version => '2.7.6',
  }

  rbenv::alias { '2.7':
    to_version => '2.7.6',
  }

  rbenv::alias { '3.0':
    to_version => '3.0.5',
  }

  rbenv::alias { '3.1':
    to_version => '3.1.2',
  }

  rbenv::alias { '3.2':
    to_version => '3.2.0',
  }
}
