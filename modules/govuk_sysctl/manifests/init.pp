# == Class: govuk_sysctl
#
# FIXME: This entire class can be removed once deployed to production.
#
class govuk_sysctl {
  sysctl { 'net.ipv4.tcp_timestamps':
    ensure  => absent,
  }
}
