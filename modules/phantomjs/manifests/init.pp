# == Class: phantomjs
#
# Install PhantomJS <http://phantomjs.org/> from the GOV.UK package archive.
#
class phantomjs {
  include govuk::ppa

  package { 'phantomjs':
    ensure  => '1.9.7-0~ppa1',
    require => Class['govuk::ppa'],
  }
}
