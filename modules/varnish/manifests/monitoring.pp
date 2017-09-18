# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class varnish::monitoring {

  file { '/var/log/varnish':
    mode    => '0755',
    owner   => 'varnishlog',
    group   => 'varnishlog',
    require => Package['varnish'],
  }

  govuk_logging::logstream { 'varnishncsa':
    logfile => '/var/log/varnish/varnishncsa.log',
    fields  => {'application' => 'varnish'},
  }

  @filebeat::prospector { 'varnishncsa':
    paths  => ['/var/log/varnish/varnishncsa.log'],
    fields => {'application' => 'varnish'},
  }

  @@icinga::check { "check_varnish_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!varnishd',
    service_description => 'varnishd not running',
    host_name           => $::fqdn,
  }

  @icinga::nrpe_config { 'check_varnish_responding':
    source => 'puppet:///modules/varnish/nrpe_check_varnish.cfg',
  }

  $app_domain = hiera('app_domain')
  $kibana_url = "https://kibana.${app_domain}"
  $hostname_prefix = split($::hostname, '-')
  $kibana_search = {
    'query' => "@source_host:${hostname_prefix[0]}* AND status:[500 TO 599]",
    'from'  => '4h',
  }

  @@icinga::check { "check_varnish_responding_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_varnish_responding',
    service_description => 'varnishd port not responding',
    host_name           => $::fqdn,
    use                 => 'govuk_urgent_priority',
    notes_url           => monitoring_docs_url(varnish-port-not-responding),
    action_url          => kibana3_url($kibana_url, $kibana_search),
  }
}
