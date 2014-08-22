# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class bundler {

  package { 'bundler':
    ensure   => '1.1.4',
    provider => 'system_gem',
  }

}
