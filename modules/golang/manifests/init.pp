# == Class: golang
#
# Installs goenv, along with a number of Go versions.  This is mainly intended
# for use on a dev VM.
#
class golang {
  include govuk_ppa

  class { 'goenv':
    global_version => '1.9.1',
    require        => Class['govuk_ppa'],
  }

  goenv::version { ['1.7.1', '1.9.1', '1.12.1']: }

  package { ['godep']:
    ensure  => latest,
    require => Class['govuk_ppa'],
  }

  # Ensure that scm tools used by `go get` are present.
  ensure_packages(['bzr', 'git', 'mercurial'])

  if $::domain == 'development'{
    file { '/etc/profile.d/gopath.sh':
      ensure => present,
      source => 'puppet:///modules/golang/etc/profile.d/gopath.sh',
    }
  }
}
