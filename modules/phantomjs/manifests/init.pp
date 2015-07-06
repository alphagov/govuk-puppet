# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class phantomjs {
  include govuk::ppa

  package { 'phantomjs':
    ensure  => '1.9.7-0~ppa1',
    require => Class['govuk::ppa'],
  }
}
