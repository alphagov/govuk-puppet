# == Class: puppet::puppetserver::nginx
#
# Install Nginx and set up configuration for a Puppetdb.
#
class puppet::puppetserver::nginx {
  include ::nginx

  nginx::config::site { 'puppetdb':
    content => template('puppet/puppetdb-vhost.conf'),
  }

  $counter_basename = "${::fqdn_metrics}.nginx_logs.puppetdb"

  nginx::log {
    'puppetdb-json.event.access.log':
      json          => true,
      logstream     => present,
      statsd_metric => "${counter_basename}.http_%{@fields.status}",
      statsd_timers => [{metric => "${counter_basename}.time_request",
                          value => '@fields.request_time'}];
    'puppetdb-error.log':
      logstream => present;
  }

  statsd::counter { "${counter_basename}.http_500": }

  @@icinga::check::graphite { "check_nginx_5xx_puppetdb_on_${::hostname}":
    target    => "transformNull(stats.${counter_basename}.http_5xx,0)",
    warning   => 0.05,
    critical  => 0.1,
    from      => '3minutes',
    desc      => 'puppetdb nginx high 5xx rate',
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(nginx-5xx-rate-too-high-for-many-apps-boxes),
  }

}
