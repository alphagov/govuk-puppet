# == Class: monitoring::checks
#
# Checks that run only from the monitoring machine
#
# === Parameters
#
# [*aws_origin_domain*]
#   the domain name used by the AWS cache load balancer
#
# [*http_username*]
#   Basic auth HTTP username
#
# [*http_password*]
#   Password for $http_username
#
class monitoring::checks (
  $aws_origin_domain              = undef,
  $http_username                  = 'UNSET',
  $http_password                  = 'UNSET',
  $whitehall_overdue_check_period = undef,
  $whitehall_scheduled_check_period = undef,
  $content_data_api_check_period  = undef,
  $signon_api_tokens_check_period = undef,
) {

  ensure_packages(['jq'])

  exec { 'install_boto':
        path    => ['/opt/python2.7/bin', '/usr/bin', '/usr/sbin'],
        command => '/opt/python2.7/bin/pip install boto',
        require => Class['::govuk_jenkins::packages::govuk_python'],
  }

  exec { 'install_boto3':
        path    => ['/opt/python2.7/bin', '/usr/bin', '/usr/sbin'],
        command => '/opt/python2.7/bin/pip install boto3',
        require => Class['::govuk_jenkins::packages::govuk_python'],
  }

  include monitoring::checks::mirror
  include monitoring::checks::sidekiq
  include monitoring::checks::smokey
  include monitoring::checks::cache
  include monitoring::checks::rds
  include monitoring::checks::lb
  include monitoring::checks::cloudwatch
  include monitoring::checks::grafana_dashboards
  include monitoring::checks::cdn_logs

  include govuk::apps::email_alert_api::checks
  include govuk::apps::publisher::unprocessed_emails_count_check

  $app_domain = hiera('app_domain')

  if $app_domain != 'integration.publishing.service.gov.uk' {
    include monitoring::checks::reboots
  }

  include icinga::plugin::check_http_timeout_noncrit

  $content_data_api_hostname    = "content-data-api.${app_domain}"
  $content_data_api_metrics_path = '/healthcheck/metrics'
  $content_data_api_search_path = '/healthcheck/search'

  include icinga::client::check_json_healthcheck

  icinga::check { "content_data_api_search_${::hostname}":
    check_command              => "check_app_health!check_json_healthcheck!443 ${content_data_api_search_path} ${content_data_api_hostname} https",
    service_description        => 'search healthcheck for content-data-api',
    use                        => 'govuk_urgent_priority',
    host_name                  => $::fqdn,
    notes_url                  => monitoring_docs_url(content-data-api-app-healthcheck-not-ok),
    check_period               => $content_data_api_check_period,
    attempts_before_hard_state => 5,
    retry_interval             => 1,
  }

  icinga::check { "content_data_api_metrics_${::hostname}":
    check_command              => "check_app_health!check_json_healthcheck!443 ${content_data_api_metrics_path} ${content_data_api_hostname} https",
    service_description        => 'metrics healthcheck for content-data-api',
    use                        => 'govuk_urgent_priority',
    host_name                  => $::fqdn,
    notes_url                  => monitoring_docs_url(content-data-api-app-healthcheck-not-ok),
    check_period               => $content_data_api_check_period,
    attempts_before_hard_state => 5,
    retry_interval             => 1,
  }

  icinga::check { "signon_api_tokens_${::hostname}":
    check_command       => "check_app_health!check_json_healthcheck!443 /healthcheck/api-tokens signon.${app_domain} https",
    service_description => 'expiring API tokens in Signon',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(expiring-api-tokens-in-signon),
    check_period        => $signon_api_tokens_check_period,
  }

  # Used in template and icinga::check.
  $whitehall_hostname    = "whitehall-admin.${app_domain}"
  $whitehall_overdue_url = '/healthcheck/overdue'
  $whitehall_scheduled_url = '/healthcheck/unenqueued_scheduled_editions'

  icinga::check_config { 'whitehall_overdue':
    content => template('monitoring/check_whitehall_overdue.cfg.erb'),
    require => Icinga::Plugin['check_http_timeout_noncrit'],
  }

  icinga::check { "check_whitehall_overdue_from_${::hostname}":
    check_command              => 'check_whitehall_overdue',
    service_description        => 'overdue publications in Whitehall',
    use                        => 'govuk_urgent_priority',
    host_name                  => $::fqdn,
    notes_url                  => monitoring_docs_url(whitehall-scheduled-publishing),
    action_url                 => "https://${whitehall_hostname}${whitehall_overdue_url}",
    event_handler              => 'publish_overdue_whitehall',
    check_period               => $whitehall_overdue_check_period,
    attempts_before_hard_state => 10,
    retry_interval             => 1,
  }

  icinga::check_config { 'whitehall_scheduled':
    content => template('monitoring/check_whitehall_scheduled.cfg.erb'),
    require => Icinga::Plugin['check_http_timeout_noncrit'],
  }

  if $::aws_environment == 'production' {
    icinga::check { "check_whitehall_scheduled_from_${::hostname}":
      check_command              => 'check_whitehall_scheduled',
      service_description        => 'scheduled publications in Whitehall not queued',
      use                        => 'govuk_urgent_priority',
      host_name                  => $::fqdn,
      notes_url                  => monitoring_docs_url(whitehall-scheduled-publishing),
      action_url                 => "https://${whitehall_hostname}${whitehall_scheduled_url}",
      check_period               => $whitehall_scheduled_check_period,
      attempts_before_hard_state => 10,
      retry_interval             => 1,
    }
  }


  icinga::check {'check_mapit_responding':
    check_command       => 'check_mapit',
    host_name           => $::fqdn,
    service_description => 'mapit not responding to postcode query',
  }

  # migration of the www-origin.*.publishing.service.gov.uk to AWS is now complete
  icinga::check { 'check_www_cert_valid_at_origin':
    # Note we connect to www-origin, but specify www.gov.uk as the server name using SNI
    check_command       => "check_ssl_cert!www-origin.${app_domain}!www.gov.uk!30",
    host_name           => $::fqdn,
    service_description => 'check the www.gov.uk TLS certificate at ORIGIN is valid and not due to expire',
    notes_url           => monitoring_docs_url(renew-tls-certificate),
  }

  icinga::check { 'check_www_cert_valid_at_aws_origin':
    # Note we connect to www-origin, but specify www.gov.uk as the server name using SNI
    check_command       => "check_ssl_cert!www-origin.${aws_origin_domain}!www.gov.uk!30",
    host_name           => $::fqdn,
    service_description => 'check the www.gov.uk TLS certificate at AWS ORIGIN is valid and not due to expire',
    notes_url           => monitoring_docs_url(renew-tls-certificate),
  }

  icinga::check { 'check_www_cert_valid_at_edge':
    check_command       => 'check_ssl_cert!www.gov.uk!www.gov.uk!30',
    host_name           => $::fqdn,
    service_description => 'check the www.gov.uk TLS certificate at EDGE is valid and not due to expire',
    notes_url           => monitoring_docs_url(renew-tls-certificate),
  }

  icinga::check { 'check_www_staging_cert_valid_at_edge':
    check_command       => 'check_ssl_cert!www.staging.publishing.service.gov.uk!www.staging.publishing.service.gov.uk!30',
    host_name           => $::fqdn,
    service_description => 'check the www.staging.publishing.service.gov.uk TLS certificate at EDGE is valid and not due to expire',
    notes_url           => monitoring_docs_url(renew-tls-certificate),
  }

  icinga::check { 'check_www_integration_cert_valid_at_edge':
    check_command       => 'check_ssl_cert!www.integration.publishing.service.gov.uk!www.integration.publishing.service.gov.uk!30',
    host_name           => $::fqdn,
    service_description => 'check the www.integration.publishing.service.gov.uk TLS certificate at EDGE is valid and not due to expire',
    notes_url           => monitoring_docs_url(renew-tls-certificate),
  }

  icinga::check { 'check_wildcard_cert_valid':
    check_command       => "check_ssl_cert!signon.${app_domain}!signon.${app_domain}!30",
    host_name           => $::fqdn,
    service_description => "check the STAR.${app_domain} TLS certificate is valid and not due to expire",
    notes_url           => monitoring_docs_url(renew-tls-certificate),
  }

  icinga::check_config { 'check_dig_cloudflare':
    source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_dig_cloudflare.cfg',
  }

  icinga::check { 'check_www_gov_uk_dns':
    check_command       => 'check_dig_cloudflare!www.gov.uk!-a www-cdn.production.govuk.service.gov.uk --timeout 10 -w 2 -c 3 -T CNAME',
    host_name           => $::fqdn,
    service_description => 'check www.gov.uk DNS record',
    require             => Icinga::Check_config['check_dig_cloudflare'],
  }

  icinga::check { 'check_ddos_detected':
    check_command       => 'check_cloudwatch!DDoSProtection!eu-west-1!DDoSDetected!0.99!0.99!--default=0',
    host_name           => $::fqdn,
    service_description => 'check AWS DDOS report',
    notes_url           => monitoring_docs_url(ddosdetected),
    check_interval      => 30,
    retry_interval      => 30,
    require             => Package['jq'],
  }

  $cdn_log_age_threshold_mins = $::aws_environment ? {
    'production' => 60,
    # Staging and Integration don't produce any logs between 22:00 and 04:00
    # when traffic replay isn't running. Fastly doesn't send us empty files.
    default      => 390,
  }
  icinga::check { 'check_cdn_log_s3_freshness_assets':
    check_command       => "check_cdn_log_s3_freshness!-e ${::aws_environment} -l govuk_assets -c ${cdn_log_age_threshold_mins}",
    host_name           => $::fqdn,
    service_description => "check that Fastly logs from ${cdn_log_age_threshold_mins}m ago appear in s3://govuk-${::aws_environment}-fastly-logs/govuk_assets",
    notes_url           => monitoring_docs_url(cdn-log-freshness),
    check_interval      => 60,
    retry_interval      => 5,
  }
  icinga::check { 'check_cdn_log_s3_freshness_www':
    check_command       => "check_cdn_log_s3_freshness!-e ${::aws_environment} -l govuk_www -c ${cdn_log_age_threshold_mins}",
    host_name           => $::fqdn,
    service_description => "check that Fastly logs from ${cdn_log_age_threshold_mins}m ago appear in s3://govuk-${::aws_environment}-fastly-logs/govuk_www",
    notes_url           => monitoring_docs_url(cdn-log-freshness),
    check_interval      => 60,
    retry_interval      => 5,
  }
  # Bouncer logs are in Production only.
  if $::aws_environment == 'production' {
    icinga::check { 'check_cdn_log_s3_freshness_bouncer':
      check_command       => "check_cdn_log_s3_freshness!-e ${::aws_environment} -l bouncer -c ${cdn_log_age_threshold_mins}",
      host_name           => $::fqdn,
      service_description => "check that Fastly logs from ${cdn_log_age_threshold_mins}m ago appear in s3://govuk-${::aws_environment}-fastly-logs/bouncer",
      notes_url           => monitoring_docs_url(cdn-log-freshness),
      check_interval      => 60,
      retry_interval      => 5,
    }
  }

  if ($::aws_environment == 'production') {
    icinga::check { 'check_uk_cloud_vpn_up':
      check_command       => 'check_uk_cloud_vpn!www.civicaepay.co.uk!/ReadingXML/QueryPayments/QueryPayments.asmx',
      host_name           => $::fqdn,
      service_description => 'check that the VPN between UKCloud/Licensify and AWS is still up',
      notes_url           => monitoring_docs_url(vpn-down),
    }
  }
}
