# == Class: statsd::repo
#
# Use our own Statsd repo
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
class statsd::repo(
  $apt_mirror_hostname = undef,
) {
  apt::source { 'statsd':
    location     => "http://${apt_mirror_hostname}/statsd",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
