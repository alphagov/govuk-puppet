# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class varnish::monitoring {

  file { '/var/log/varnish':
    mode    => '0755',
    owner   => 'varnishlog',
    group   => 'varnishlog',
    require => Package['varnish'],
  }

  collectd::plugin::process { 'service-varnish':
    regex  => 'varnishd',
  }

  collectd::plugin::tcpconn { 'service-varnish':
    incoming => 7999,
    outgoing => 7999,
  }

  @filebeat::prospector { 'varnishncsa':
    paths  => ['/var/log/varnish/varnishncsa.log'],
    fields => {'application' => 'varnish'},
    json   => true,
  }

  @@icinga::check { "check_varnish_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!varnishd',
    service_description => 'varnishd not running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }

  @icinga::nrpe_config { 'check_varnish_responding':
    source => 'puppet:///modules/varnish/nrpe_check_varnish.cfg',
  }

  $app_domain = hiera('app_domain')
  $hostname_prefix = split($::hostname, '-')

  @@icinga::check { "check_varnish_responding_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_varnish_responding',
    service_description => 'varnishd port not responding',
    host_name           => $::fqdn,
    use                 => 'govuk_urgent_priority',
    notes_url           => monitoring_docs_url(varnish-port-not-responding),
  }
}
