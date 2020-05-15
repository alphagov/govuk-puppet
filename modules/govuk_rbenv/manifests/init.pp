# Class: govuk_rbenv
#
# Installs rbenv and the base set of rubies.  This is intended to provide the
# rubies that are needed on all machines - mainly to run puppet etc.
#
class govuk_rbenv {
  include rbenv

  # @FIXME - Check once [ffi-gem](https://github.com/ffi/ffi) is past 1.9.21
  # whether we still need to require this.
  # It was added in as many ruby apps are installed with 1.9.21 and are
  # failing to install some environments where this is not required.
  ensure_packages(['libffi-dev'])

  unless $::lsbdistcodename == 'xenial' {
    rbenv::version { '1.9.3-p550':
      bundler_version  => '1.17.3',
      install_gem_docs => false,
    }
    rbenv::alias { '1.9.3':
      to_version => '1.9.3-p550',
    }
  }
}
