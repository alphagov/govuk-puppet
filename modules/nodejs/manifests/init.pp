# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class nodejs {
  package { 'nodejs':
    ensure  => '0.6.12~dfsg1-1ubuntu1',
  }
}
