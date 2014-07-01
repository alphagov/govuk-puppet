class govuk_rabbitmq::repo {
  apt::source { 'rabbitmq':
    location     => 'http://apt.production.alphagov.co.uk/rabbitmq',
    release      => 'testing',
    architecture => $::architecture,
    key          => '37E3ACBB',
  }
}
