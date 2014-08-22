# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class aspell {
  # For generating spelling suggestions
  package { ['aspell', 'aspell-en', 'libaspell-dev']:
    ensure => installed,
  }
}
