# == Class: govuk::tagalog
#
# Install tagalog, which provides logship, used by govuk::logstream
#
class govuk::tagalog {
  package { 'tagalog':
    ensure   => '0.4.0',
    provider => 'pip',
  }
}
