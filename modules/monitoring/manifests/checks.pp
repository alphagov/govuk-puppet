class monitoring::checks {

  include monitoring::checks::fastly
  include monitoring::checks::mirror
  include monitoring::checks::pingdom
  include monitoring::checks::ses
  include monitoring::checks::smokey

  $app_domain = hiera('app_domain')
  $http_username = extlookup('http_username', 'UNSET')
  $http_password = extlookup('http_password', 'UNSET')

  icinga::plugin { 'check_http_timeout_noncrit':
    source => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_http_timeout_noncrit',
  }

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
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#whitehall-scheduled-publishing',
    action_url          => "https://${whitehall_hostname}${whitehall_overdue_url}",
  }
  # END whitehall

  # START datainsight
  $datainsight_base_uri = "https://${http_username}:${http_password}@datainsight-frontend.${app_domain}/performance/dashboard"

  icinga::plugin { 'check_datainsight_recorder':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_datainsight_recorder.rb',
  }

  icinga::check { 'check_datainsight_hourly_traffic_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/hourly-traffic.json 60",
    host_name           => $::fqdn,
    service_description => 'checks if datainsight endpoint for gov.uk hourly traffic is updated regularly',
  }

  icinga::check { 'check_datainsight_visits_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/visits.json 10080",
    host_name           => $::fqdn,
    service_description => 'checks if datainsight endpoint for gov.uk visits is updated regularly',
  }

  icinga::check { 'check_datainsight_unique_visitors_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/unique-visitors.json 10080",
    host_name           => $::fqdn,
    service_description => 'checks if datainsight endpoint for gov.uk visitors is updated regularly',
  }

  icinga::check { 'check_datainsight_format_success_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/content-engagement.json 10080",
    host_name           => $::fqdn,
    service_description => 'checks if datainsight endpoint for gov.uk content engagement is updated regularly',
  }

  icinga::check { 'check_datainsight_insidegov_weekly_visitors_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/government/visitors/weekly.json 10080",
    host_name           => $::fqdn,
    service_description => 'checks if datainsight endpoint for insidegov visitors is updated regularly',
  }

  icinga::check { 'check_datainsight_insidegov_policies_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/government/most-entered-policies.json 10080",
    host_name           => $::fqdn,
    service_description => 'checks if datainsight endpoint for insidegov most entered policies is updated regularly',
  }

  icinga::check { 'check_datainsight_insidegov_content_engagement_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/government/content-engagement.json 10080",
    host_name           => $::fqdn,
    service_description => 'checks if datainsight endpoint for insidegov content engagement is updated regularly',
  }
  # END datainsight

  $warning_time = 5
  $critical_time = 10

  # START limelight
  $limelight_hostname = "limelight.${app_domain}"

  icinga::check { 'check_limelight_endpoint':
    check_command       => "check_https_url!${limelight_hostname}!/_status!${warning_time}!${critical_time}",
    host_name           => $::fqdn,
    service_description => 'checks if limelight homepage is up',
  }
  # END limelight

  icinga::check {'check_mapit_responding':
    check_command       => 'check_mapit',
    host_name           => $::fqdn,
    service_description => 'mapit not responding to postcode query',
  }

  # START ssl certificate checks
  icinga::check { 'check_wildcard_cert_valid':
    check_command       => "check_ssl_cert!signon.${app_domain}!30",
    host_name           => $::fqdn,
    service_description => "check the STAR.${app_domain} SSL certificate is valid and not due to expire",
  }
  # END ssl certificate checks

  # START signon
  icinga::check::graphite { 'check_signon_queue_sizes':
    # Check signon background worker average queue sizes over a 5 min period
    target    => 'summarize(stats.gauges.govuk.app.signon.workers.*.enqueued,"5mins","avg")',
    warning   => 30,
    critical  => 50,
    desc      => 'signon background worker queue size unexpectedly large',
    host_name => $::fqdn,
  }
  # END signon

  # START support
  icinga::check::graphite { 'check_support_default_queue_size':
    target    => 'stats.gauges.govuk.app.support.queues.default',
    warning   => 10,
    critical  => 20,
    desc      => 'support app background processing: unexpectedly large default queue size',
    host_name => $::fqdn,
  }
  # END support

  icinga::timeperiod { '24x7':
    timeperiod_alias => '24 Hours A Day, 7 Days A Week',
    sun              => '00:00-24:00',
    mon              => '00:00-24:00',
    tue              => '00:00-24:00',
    wed              => '00:00-24:00',
    thu              => '00:00-24:00',
    fri              => '00:00-24:00',
    sat              => '00:00-24:00',
  }

  icinga::timeperiod { 'workhours':
    timeperiod_alias => 'Standard Work Hours',
    mon              => '09:00-17:00',
    tue              => '09:00-17:00',
    wed              => '09:00-17:00',
    thu              => '09:00-17:00',
    fri              => '09:00-17:00',
  }

  icinga::timeperiod { 'nonworkhours':
    timeperiod_alias => 'Non-Work Hours',
    sun              => '00:00-24:00',
    mon              => '00:00-09:00,16:00-24:00',
    tue              => '00:00-09:00,16:00-24:00',
    wed              => '00:00-09:00,16:00-24:00',
    thu              => '00:00-09:00,16:00-24:00',
    fri              => '00:00-09:00,17:00-24:00',
    sat              => '00:00-24:00',
  }

  icinga::timeperiod { 'never':
    timeperiod_alias => 'Never'
  }

  #TODO: extlookup or hiera for email addresses?
  $contact_email = extlookup('monitoring_group', 'root@localhost')

  icinga::contact { 'monitoring_google_group':
    email => $contact_email
  }

  icinga::pager_contact { 'pager_nonworkhours':
    service_notification_options => 'c',
    notification_period          => '24x7',
  }

  # End Zendesk Groups

  icinga::service_template { 'govuk_regular_service':
    contact_groups => ['regular']
  }

  icinga::service_template { 'govuk_urgent_priority':
    contact_groups => ['urgent-priority']
  }

  icinga::service_template { 'govuk_high_priority':
    contact_groups => ['high-priority']
  }

  icinga::service_template { 'govuk_normal_priority':
    contact_groups => ['normal-priority']
  }

  icinga::service_template { 'govuk_low_priority':
    contact_groups => ['regular']
  }

  icinga::service_template { 'govuk_unprio_priority':
    contact_groups => ['regular']
  }

}
