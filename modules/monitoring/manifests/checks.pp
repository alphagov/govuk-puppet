# == Class: monitoring::checks
#
# Checks that run only from the monitoring machine
#
# === Parameters
#
# [*http_username*]
#   Basic auth HTTP username
#
# [*http_password*]
#   Password for $http_username
#
# [*enable_support_check*]
#   Enable monitoring for check_support_default_queue_size
#
class monitoring::checks (
  $http_username = 'UNSET',
  $http_password = 'UNSET',
  $enable_support_check = true,
) {
  include monitoring::checks::mirror
  include monitoring::checks::pingdom
  include monitoring::checks::ses
  include monitoring::checks::sidekiq
  include monitoring::checks::smokey
  include monitoring::checks::reboots

  $app_domain = hiera('app_domain')

  include icinga::plugin::check_http_timeout_noncrit

  # START whitehall
  # Used in template and icinga::check.
  $whitehall_hostname    = "whitehall-admin.${app_domain}"
  $whitehall_overdue_url = '/healthcheck/overdue'

  icinga::check_config { 'whitehall_overdue':
    content => template('monitoring/check_whitehall_overdue.cfg.erb'),
    require => Icinga::Plugin['check_http_timeout_noncrit'],
  }

  icinga::check { "check_whitehall_overdue_from_${::hostname}":
    check_command       => 'check_whitehall_overdue',
    service_description => 'overdue publications in Whitehall',
    use                 => 'govuk_urgent_priority',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(whitehall-scheduled-publishing),
    action_url          => "https://${whitehall_hostname}${whitehall_overdue_url}",
  }
  # END whitehall

  $warning_time = 5
  $critical_time = 10

  icinga::check {'check_mapit_responding':
    check_command       => 'check_mapit',
    host_name           => $::fqdn,
    service_description => 'mapit not responding to postcode query',
  }

  # START ssl certificate checks
  icinga::check { 'check_www_cert_valid_at_origin':
    # Note we connect to www-origin, but specify www.gov.uk as the server name using SNI
    check_command       => "check_ssl_cert!www-origin.${app_domain}!www.gov.uk!30",
    host_name           => $::fqdn,
    service_description => 'check the www.gov.uk SSL certificate at ORIGIN is valid and not due to expire',
  }
  icinga::check { 'check_www_cert_valid_at_edge':
    check_command       => 'check_ssl_cert!www.gov.uk!www.gov.uk!30',
    host_name           => $::fqdn,
    service_description => 'check the www.gov.uk SSL certificate at EDGE is valid and not due to expire',
  }
  icinga::check { 'check_wildcard_cert_valid':
    check_command       => "check_ssl_cert!signon.${app_domain}!signon.${app_domain}!30",
    host_name           => $::fqdn,
    service_description => "check the STAR.${app_domain} SSL certificate is valid and not due to expire",
  }
  icinga::check { 'check_mirror_provider0_cert_valid':
    check_command       => 'check_ssl_cert!www-origin.mirror.provider0.production.govuk.service.gov.uk!www-origin.mirror.provider0.production.govuk.service.gov.uk!30',
    host_name           => $::fqdn,
    service_description => 'check the provider0 mirror SSL certificate is valid and not due to expire',
  }
  icinga::check { 'check_mirror_provider1_cert_valid':
    check_command       => 'check_ssl_cert!www-origin.mirror.provider1.production.govuk.service.gov.uk!www-origin.mirror.provider1.production.govuk.service.gov.uk!30',
    host_name           => $::fqdn,
    service_description => 'check the provider1 mirror SSL certificate is valid and not due to expire',
  }
  # END ssl certificate checks

  # START signon
  icinga::check::graphite { 'check_signon_queue_sizes':
    # Check signon background worker average queue sizes over a 5 min period
    target    => 'summarize(stats.gauges.govuk.app.signon.workers.queues.*.enqueued,"5mins","avg")',
    warning   => 30,
    critical  => 50,
    desc      => 'signon background worker queue size unexpectedly large',
    host_name => $::fqdn,
  }
  # END signon

  if $enable_support_check {
    icinga::check::graphite { 'check_support_default_queue_size':
      target    => 'stats.gauges.govuk.app.support.queues.default',
      warning   => 10,
      critical  => 20,
      desc      => 'support app background processing: unexpectedly large default queue size',
      host_name => $::fqdn,
    }
  }

  icinga::plugin { 'check_hsts_headers':
    source => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_hsts_headers',
  }

  icinga::check_config { 'check_hsts_headers':
    content => template('monitoring/check_hsts_headers.cfg.erb'),
    require => Icinga::Plugin['check_hsts_headers'],
  }

  icinga::check { "check_hsts_headers_from_${::hostname}":
    check_command       => 'check_hsts_headers',
    service_description => 'Strict-Transport-Security headers',
    host_name           => $::fqdn,
  }

  icinga::check_config { 'check_puppetdb_ssh_host_keys':
    source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_puppetdb_ssh_host_keys.cfg',
    require => Class['monitoring::client'],
  }

  icinga::check { "check_puppetdb_ssh_host_keys_from_${::hostname}":
    check_command       => 'check_puppetdb_ssh_host_keys',
    service_description => 'duplicate SSH host keys',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(duplicate-ssh-host-keys),
    require             => Icinga::Check_config['check_puppetdb_ssh_host_keys'],
  }
}
