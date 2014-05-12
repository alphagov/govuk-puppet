# == Class: govuk_elasticsearch::repo
#
# Use our own mirror of the ES repo. Should be used with `manage_repo`
# disable of the upstream module.
#
# This *has* to be in a class otherwise there will be a dependency loop
# caused by a relationship between govuk_elasticsearch,
# govuk_java::oracle7::jdk, and apt::source.
#
class govuk_elasticsearch::repo {
  apt::source { 'elasticsearch-0.90':
    location     => 'http://apt.production.alphagov.co.uk/elasticsearch-0.90',
    release      => 'stable',
    architecture => $::architecture,
    key          => '37E3ACBB',
  }
}
