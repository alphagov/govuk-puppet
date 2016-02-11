# == Class: govuk::logging
#
# Install tagalog, which provides logship, used by govuk::logstream
#
class govuk_logging {
  package { 'tagalog':
    ensure   => '0.4.0',
    provider => 'pip',
  }
}
