class varnish::service {

  service { 'varnish':
    ensure     => running,
    hasrestart => false,
    restart    => '/usr/sbin/service varnish reload',
  }

  # Sysv scripts always return exit code 0 on all dists.
  service { 'varnishncsa':
    ensure    => running,
    status    => '/etc/init.d/varnishncsa status | grep \'varnishncsa is running\'',
    hasstatus => false,
    require   => Service['varnish'],
  }

  @logster::cronjob { 'varnish':
    file   => '/var/log/varnish/varnishncsa.log',
    prefix => 'varnish_logs',
  }

  govuk::logstream { 'varnishncsa':
    logfile => '/var/log/varnish/varnishncsa.log',
    fields  => {'application' => 'varnish'},
    require => Service['varnishncsa'],
  }

  # FIXME: keepLastValue() because logster only runs every 2m.
  @@nagios::check::graphite { "check_varnish_5xx_${::hostname}":
    target    => "keepLastValue(${::fqdn_underscore}.varnish_logs.http_5xx)",
    warning   => 1,
    critical  => 2,
    args      => '--from 3minutes',
    desc      => 'router varnish high 5xx rate',
    host_name => $::fqdn,
  }

  @@nagios::check { "check_varnish_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!varnishd',
    service_description => 'varnishd not running',
    host_name           => $::fqdn,
  }

  @nagios::nrpe_config { 'check_varnish_responding':
    source => 'puppet:///modules/varnish/nrpe_check_varnish.cfg',
  }

  @@nagios::check { "check_varnish_responding_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_varnish_responding',
    service_description => 'varnishd port not responding',
    host_name           => $::fqdn,
  }
}
