# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class varnish::monitoring {
  govuk::logstream { 'varnishncsa':
    logfile => '/var/log/varnish/varnishncsa.log',
    fields  => {'application' => 'varnish'},
  }

  @@icinga::check { "check_varnish_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!varnishd',
    service_description => 'varnishd not running',
    host_name           => $::fqdn,
  }

  @icinga::nrpe_config { 'check_varnish_responding':
    source => 'puppet:///modules/varnish/nrpe_check_varnish.cfg',
  }

  $monitoring_domain_suffix = hiera('monitoring_domain_suffix', '')
  @@icinga::check { "check_varnish_responding_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_varnish_responding',
    service_description => 'varnishd port not responding',
    host_name           => $::fqdn,
    use                 => 'govuk_urgent_priority',
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#varnish-port-not-responding',
    action_url          => "https://graphite.${monitoring_domain_suffix}/render?from=-8hours&until=now&width=800&height=600&target=alias%28stats.cache-1_router_production.nginx_logs.www-origin.http_5xx,%27cache-1%20HTTP%205xx%20Errors%27%29&target=alias%28stats.cache-2_router_production.nginx_logs.www-origin.http_5xx,%27cache-2%20HTTP%205xx%20Errors%27%29&target=alias%28stats.cache-3_router_production.nginx_logs.www-origin.http_5xx,%27cache-3%20HTTP%205xx%20Errors%27%29&title=Error%20Rates%20at%20Caches",
  }
}
