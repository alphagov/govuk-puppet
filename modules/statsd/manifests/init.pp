# == Class: statsd
#
# This class installs and sets-up statsd
#
class statsd(
  $graphite_hostname
) {
  include govuk_ppa
  include nodejs

  if $::lsbdistcodename == 'xenial' {
    apt::source { 'statsd':
      location     => "http://${apt_mirror_hostname}/statsd",
      release      => $::lsbdistcodename,
      architecture => $::architecture,
      key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
    }
  }

  package { 'statsd':
    ensure  => 'latest',
    require => Class['nodejs'],
  }

  file { '/etc/statsd.conf':
    content => template('statsd/etc/statsd.conf.erb'),
    require => Package['statsd'],
    notify  => Service['statsd'],
  }

  service { 'statsd':
    ensure  => running,
    require => [Package['statsd'], File['/etc/statsd.conf']],
  }

  @@icinga::check { "check_statsd_upstart_up_${::hostname}":
    check_command       => 'check_nrpe!check_upstart_status!statsd',
    service_description => 'statsd upstart up',
    host_name           => $::fqdn,
  }
}
