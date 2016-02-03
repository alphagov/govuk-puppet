# == Class: golang
#
# Installs goenv, along with a number of Go versions.  This is mainly intended
# for use on a dev VM.
#
class golang {
  include govuk::ppa

  class { 'goenv':
    global_version => '1.5.3',
    require        => Class['govuk::ppa'],
  }
  goenv::version { ['1.3.3', '1.4.2', '1.4.3', '1.5.1', '1.5.3']: }

  # FIXME: Remove once cleaned up everywhere.
  goenv::version { ['1.2.2', '1.3.1', '1.4.1']:
    ensure => absent,
  }

  package { ['golang-gom', 'godep']:
    ensure  => latest,
    require => Class['govuk::ppa'],
  }

  # Ensure that scm tools used by `go get` are present.
  ensure_packages(['bzr', 'git', 'mercurial'])
}
