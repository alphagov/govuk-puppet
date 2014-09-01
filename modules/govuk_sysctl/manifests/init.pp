# == Class: govuk_sysctl
#
# FIXME: This entire class can be removed once deployed to production.
#
class govuk_sysctl {
  sysctl {
    'disable-timestamps':
      ensure  => absent,
      prefix  => 10;
    'net.ipv4.tcp_timestamps':
      value   => 1,
      comment => ['Restore default Ubuntu setting of `1`'];
  }
}
