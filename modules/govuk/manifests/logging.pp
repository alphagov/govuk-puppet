# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::logging {
  # tagalog provides logship, used by govuk::logstream
  package { 'tagalog':
    ensure   => '0.4.0',
    provider => 'pip',
  }
}
