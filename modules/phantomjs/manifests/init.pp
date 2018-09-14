# == Class: phantomjs
#
# Install PhantomJS <http://phantomjs.org/> from the GOV.UK package archive.
#
class phantomjs {
  include govuk_ppa

  package { 'phantomjs':
    ensure  => absent,
    require => Class['govuk_ppa'],
  }
}
