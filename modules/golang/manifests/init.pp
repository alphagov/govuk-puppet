class golang {
  if $::lsbdistcodename == 'precise' {
    include govuk::ppa

    package { 'golang':
      ensure  => '2:1.2.2-0~ppa1~precise1',
      require => Class['govuk::ppa'],
    }

    ensure_packages(['bzr'])
  } else {
    warning "Go packages not available for this distibution (${::lsbdistcodename})"
  }
}
