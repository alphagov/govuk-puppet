# == Class: golang
#
# Installs goenv, along with a number of Go versions.  This is mainly intended
# for use on a dev VM.
#
class golang {
  include govuk::ppa

  class { 'goenv':
    global_version => '1.2.2',
  }
  goenv::version { ['1.2.2', '1.3.1']: }

  ensure_packages(['bzr'])

  # FIXME remove once cleaned up everywhere.
  package { ['golang', 'golang-doc', 'golang-go', 'golang-go-linux-amd64', 'golang-src']:
    ensure => purged,
  }
}
