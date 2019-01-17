# == Class: nginx
#
# Sets up Nginx on a machine
#
# === Parameters
#
# [*server_names_hash_max_size*]
# [*variables_hash_max_size*]
# [*denied_ip_addresses*]
#   Passed through to `nginx::config`, see the documentation there.
#
class nginx (
  $server_names_hash_max_size = 512,
  $variables_hash_max_size = 1024,
  $denied_ip_addresses = []) {

  limits::limits { 'www-data_nofile':
    ensure     => present,
    user       => 'www-data',
    limit_type => 'nofile',
    both       => 16384,
  }

  contain nginx::package
  contain nginx::logging
  contain nginx::firewall
  contain nginx::service

  class { 'nginx::config':
    server_names_hash_max_size => $server_names_hash_max_size,
    variables_hash_max_size    => $variables_hash_max_size,
    denied_ip_addresses        => $denied_ip_addresses,
  }

  Class['nginx::package'] -> Class['nginx::config']
  Class['nginx::package'] -> Class['nginx::logging']
  Class['nginx::config'] -> Class['nginx::firewall']
  Class['nginx::config'] ~> Class['nginx::service']
  Class['nginx::package'] ~> Class['nginx::service']

  # Include ability to do a full restart of nginx. This does not explicitly
  # trigger a restart, but simply makes the class available to any manifest
  # that `include`s nginx.
  include nginx::restart

  class { 'collectd::plugin::nginx':
    status_url => 'http://127.0.0.234/nginx_status',
    require    => Class['nginx::config'],
  }

  # Monitoring of NginX
  nginx::config::site { 'monitoring-vhost.test':
    source  => 'puppet:///modules/nginx/sites/monitoring-vhost-nginx.conf',
  }

  @@icinga::check { "check_nginx_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!nginx',
    service_description => 'nginx not running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }

  if $::aws_migration {
    @icinga::nrpe_config { 'check_http_local':
      source => 'puppet:///modules/nginx/etc/nagios/nrpe.d/check_http_local.cfg',
    }

    @@icinga::check { "check_http_response_${::hostname}":
      check_command       => 'check_nrpe!check_http_local!monitoring-vhost.test 5 10',
      service_description => 'nginx http port unresponsive',
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(check-process-running),
    }
  } else {
    @@icinga::check { "check_http_response_${::hostname}":
      check_command       => 'check_http_port!monitoring-vhost.test!5!10',
      service_description => 'nginx http port unresponsive',
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(check-process-running),
    }
  }

  collectd::plugin::tcpconn { 'https':
    incoming => 443,
    outgoing => 443,
  }

  collectd::plugin::tcpconn { 'http':
    incoming => 80,
    outgoing => 80,
  }
}
