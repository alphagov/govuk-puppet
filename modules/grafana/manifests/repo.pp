# == Class: grafana::repo
#
class grafana::repo {
  apt::source { 'grafana':
    location     => 'http://apt_mirror.cluster/grafana',
    release      => 'jessie',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
