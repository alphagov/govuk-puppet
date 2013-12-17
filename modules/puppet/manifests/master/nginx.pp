class puppet::master::nginx {
  include ::nginx

  nginx::config::site { 'puppetmaster':
    content => template('puppet/puppetmaster-vhost.conf'),
  }

  nginx::log {
    'puppetmaster-json.event.access.log':
      json          => true,
      logstream     => true,
      statsd_metric => "${$::fqdn_underscore}.nginx_logs.puppetmaster.http_%{@fields.status}",
      statsd_timers => [{metric => "${::fqdn_underscore}.nginx_logs.puppetmaster.time_request",
                          value => '@fields.request_time'}];
    'puppetmaster-access.log':
      logstream => false;
    'puppetmaster-error.log':
      logstream => true;
  }

  @logster::cronjob { 'nginx-vhost-puppetmaster':
    file    => '/var/log/nginx/puppetmaster-access.log',
    prefix  => 'nginx_logs.puppetmaster',
  }

  @logrotate::conf { 'puppetmaster':
    matches => '/var/log/puppetmaster/*.log',
  }

  @@nagios::check::graphite { "check_nginx_5xx_puppetmaster_on_${::hostname}":
    target    => "transformNull(stats.${::fqdn_underscore}.nginx_logs.puppetmaster.http_5xx,0)",
    warning   => 0.05,
    critical  => 0.1,
    from      => '3minutes',
    desc      => 'puppetmaster nginx high 5xx rate',
    host_name => $::fqdn,
    notes_url => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html?highlight=nagios#nginx-5xx-rate-too-high-for-many-apps-boxes',
  }
}
