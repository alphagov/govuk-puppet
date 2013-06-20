class govuk::logging {
  # tagalog provides logship, used by govuk::logstream
  package { 'tagalog':
    ensure   => '0.3.2',
    provider => 'pip',
  }
}
