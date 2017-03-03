# == Class: govuk_rabbitmq::repo
#
class govuk_rabbitmq::repo {
  apt::source { 'rabbitmq':
    location     => 'http://apt_mirror.cluster/rabbitmq',
    release      => 'testing',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
