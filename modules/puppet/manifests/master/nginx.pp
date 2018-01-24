# == Class: puppet::master::nginx
#
# Install Nginx and set up configuration for a Puppetmaster.
#
# === Parameters
#
# [*unicorn_port*]
#   Specify the port on which unicorn (and hence the puppetmaster) should
#   listen.
#
class puppet::master::nginx (
  $unicorn_port,
) {
  include ::nginx

  nginx::config::site { 'puppetmaster':
    content => template('puppet/puppetmaster-vhost.conf'),
  }

  $counter_basename = "${::fqdn_metrics}.nginx_logs.puppetmaster"

  nginx::log {
    'puppetmaster-json.event.access.log':
      json          => true,
      logstream     => present,
      statsd_metric => "${counter_basename}.http_%{status}",
      statsd_timers => [{metric => "${counter_basename}.time_request",
                          value => 'request_time'}];
    'puppetmaster-error.log':
      logstream => present;
  }

  @logrotate::conf { 'puppetmaster':
    matches => '/var/log/puppetmaster/*.log',
  }

  statsd::counter { "${counter_basename}.http_500": }

  @@icinga::check::graphite { "check_nginx_5xx_puppetmaster_on_${::hostname}":
    target    => "transformNull(stats.${counter_basename}.http_5xx,0)",
    warning   => 0.05,
    critical  => 0.1,
    from      => '3minutes',
    desc      => 'puppetmaster nginx high 5xx rate',
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(nginx-5xx-rate-too-high-for-many-apps-boxes),
  }
}
