# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class icinga::config::slack {
  package {'icinga-slack-webhook':
    ensure   => '2.0.0',
    provider => pip3,
  }
}
