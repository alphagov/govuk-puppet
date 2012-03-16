class varnish::service {
  include logster
  include graylogtail

  service { 'varnish':
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    require    => Class['varnish::install']
  }
  service { 'varnishncsa':
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    require    => Class['varnish::install']
  }
  service { 'varnishlog':
    ensure     => running,
    hasrestart => true,
    require    => Class['varnish::install']
  }

  cron { 'logster-varnish':
    command => '/usr/sbin/logster SampleGangliaLogster /var/log/varnish/varnishncsa.log',
    user    => root,
    minute  => '*/2'
  }

  graylogtail::collect { 'graylogtail-varnish':
    log_file => '/var/log/varnish/varnishncsa.log',
    facility => 'varnish',
  }

  @@nagios_service { "check_varnish_5xx_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_ganglia_metric!http_5xx!0.03!0.1',
    service_description => "check varnish error rate for ${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
  }

  File['/etc/default/varnish'] ~> Service['varnish']
  File['/etc/varnish/default.vcl'] ~> Service['varnish']
}
