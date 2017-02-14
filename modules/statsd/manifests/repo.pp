# == Class: statsd::repo
#
# Use our own Statsd repo
#
class statsd::repo {
  apt::source { 'statsd':
    location     => 'http://apt_mirror.cluster/statsd',
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
