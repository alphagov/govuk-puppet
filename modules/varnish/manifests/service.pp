class varnish::service {

  service { 'varnish':
    ensure     => running,
    hasrestart => false,
    restart    => '/usr/sbin/service varnish reload',
    hasstatus  => false,
    status     => '/etc/init.d/varnish status | grep \'varnishd is running\'',
    require    => Class['varnish::package']
  }

  service { 'varnishncsa':
    ensure  => running,
    status  => '/etc/init.d/varnishncsa status | grep \'varnishncsa is running\'',
    require => [Class['varnish::package'], Service['varnish']]
  }

  @ganglia::pyconf { 'varnish':
    source  => 'puppet:///modules/varnish/etc/ganglia/conf.d/varnish.pyconf',
  }

  @ganglia::pymod { 'varnish':
    source  => 'puppet:///modules/varnish/usr/lib/ganglia/python_modules/varnish.py',
  }

  @logster::cronjob { 'varnish':
    args => 'SampleGangliaLogster /var/log/varnish/varnishncsa.log',
  }

  @@nagios::check { "check_varnish_5xx_${::hostname}":
    check_command       => 'check_ganglia_metric!http_5xx!0.03!0.1',
    service_description => "check varnish error rate for ${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
    require             => Logster::Cronjob['varnish'],
  }

  @@nagios::check { "check_varnish_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!varnishd',
    service_description => "check varnishd running on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  # This check is too noisy
  #@@nagios::check { "check_varnish_cache_miss_${::hostname}":
  #  check_command       => 'check_ganglia_metric!varnish_cache_hit_ratio!0:50!0:30',
  #  service_description => "check varnish cache hit ratio for ${::hostname}",
  #  host_name           => "${::govuk_class}-${::hostname}",
  #}

  @logstash::collector { 'varnish':
    source  => 'puppet:///modules/varnish/etc/logstash/logstash-client/varnish.conf',
  }

  File['/etc/default/varnish'] ~> Service['varnish']
  File['/etc/varnish/default.vcl'] ~> Service['varnish']
}
