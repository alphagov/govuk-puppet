# Class: govuk_rbenv
#
# Installs rbenv and the base set of rubies.  This is intended to provide the
# rubies that are needed on all machines - mainly to run puppet etc.
#
class govuk_rbenv {
  include rbenv

  unless $::lsbdistcodename == 'xenial' {
    rbenv::version { '1.9.3-p550':
      bundler_version => '1.7.4',
    }
    rbenv::alias { '1.9.3':
      to_version => '1.9.3-p550',
    }
  }

}
