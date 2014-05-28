class phantomjs {
  if $::lsbdistcodename == 'precise' {
    include govuk::ppa

    package { 'phantomjs':
      ensure  => '1.9.7-0~ppa1',
      require => Class['govuk::ppa'],
    }

    # FIXME: remove when this has been run everywhere
    file { '/usr/local/bin/phantomjs':
      ensure  => absent,
    }
  } else {
    warning "Phantomjs packages not available for this distibution (${::lsbdistcodename})"
  }
}
