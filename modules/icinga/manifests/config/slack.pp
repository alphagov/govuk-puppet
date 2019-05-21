# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class icinga::config::slack {
  package {'icinga-slack-webhook':
    ensure   => '2.1.1',
    provider => pip3,
  }
}
