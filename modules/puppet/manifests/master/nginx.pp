# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class puppet::master::nginx {
  include ::nginx

  $log_basename = 'puppetmaster'
  # FIXME: Remove with tagalog.
  $counter_basename = "${::fqdn_underscore}.nginx_logs.puppetmaster"

  nginx::config::site { 'puppetmaster':
    content => template('puppet/puppetmaster-vhost.conf'),
  }

  nginx::log {
    'puppetmaster-json.event.access.log':
      json          => true,
      logstream     => present,
      statsd_metric => "${counter_basename}.http_%{@fields.status}",
      statsd_timers => [{metric => "${counter_basename}.time_request",
                          value => '@fields.request_time'}];
    # FIXME: Remove when stopped.
    'puppetmaster-error.log':
      logstream => absent;
  }

  @logrotate::conf { 'puppetmaster':
    matches => '/var/log/puppetmaster/*.log',
  }

  @@icinga::check::graphite { "check_nginx_5xx_puppetmaster_on_${::hostname}":
    target    => "sumSeries(transformNull(stats.counters.${::fqdn_underscore}.nginx.${log_basename}.http_5??.rate,0))",
    warning   => 0.05,
    critical  => 0.1,
    from      => '3minutes',
    desc      => 'puppetmaster nginx high 5xx rate',
    host_name => $::fqdn,
    notes_url => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html?highlight=nagios#nginx-5xx-rate-too-high-for-many-apps-boxes',
  }
}
