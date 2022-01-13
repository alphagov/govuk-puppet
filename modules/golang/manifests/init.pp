# == Class: golang
#
# Installs goenv, along with a number of Go versions.  This is mainly intended
# for use on a dev VM.
#
class golang {
  include govuk_ppa

  class { 'goenv':
    global_version => '1.15.8',
    require        => Class['govuk_ppa'],
  }

  goenv::version { [
    '1.7.1',   # Used by alphagov/govuk_crawler_worker
    '1.11.13', # Used by alphagov/router
    '1.12.1',  # Used by alphagov/govuk-csp-forwarder
    '1.15.8',  # Used by alphagov/router
    '1.17.6',  # Used by alphagov/router
    ]: }

  package { ['godep']:
    ensure  => latest,
    require => Class['govuk_ppa'],
  }

  # Ensure that scm tools used by `go get` are present.
  ensure_packages(['bzr', 'git', 'mercurial'])
}
