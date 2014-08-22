# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_rabbitmq::repo {
  apt::source { 'rabbitmq':
    location     => 'http://apt.production.alphagov.co.uk/rabbitmq',
    release      => 'testing',
    architecture => $::architecture,
    key          => '37E3ACBB',
  }
}
