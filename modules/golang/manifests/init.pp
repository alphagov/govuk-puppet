class golang {

  # Purge the gophers version that was installed
  package { 'golang-stable':
    ensure => purged,
  }
  file {"/etc/apt/sources.list.d/gophers-go-${::lsbdistcodename}.list":
    ensure => absent,
    notify => Class['apt::update'],
  }

  if $::lsbdistcodename == 'precise' {
    include govuk::ppa

    package { 'golang':
      ensure  => "2:1.1.2",
      require => Class['govuk::ppa'],
    }

    ensure_packages(['bzr'])
  } else {
    warning "Go packages not available for this distibution (${::lsbdistcodename})"
  }
}
