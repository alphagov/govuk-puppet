class golang {
  include govuk::ppa

  package { 'golang':
    ensure  => '2:1.2.2-0~ppa1~precise1',
    require => Class['govuk::ppa'],
  }

  ensure_packages(['bzr'])
}
