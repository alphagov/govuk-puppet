class monitoring::checks {

  include monitoring::checks::pingdom
  include monitoring::checks::smokey

  $app_domain = extlookup('app_domain')
  $http_username = extlookup('http_username', 'UNSET')
  $http_password = extlookup('http_password', 'UNSET')

  # START frontend
  @@nagios::check::graphite { 'check_frontend_to_exit_404_rejects':
    target    => 'hitcount(sumSeries(stats.govuk.app.frontend.*.request.exit.404),"5minutes")',
    warning   => 50,
    critical  => 100,
    desc      => 'check volume of 404 rejects for exit links',
    host_name => $::fqdn,
  }
  # END frontend

  # START whitehall
  nagios::check { "check_whitehall_overdue_from_${::hostname}":
    check_command       => 'check_whitehall_overdue',
    service_description => 'overdue publications in Whitehall',
    use                 => 'govuk_urgent_priority',
    host_name           => $::fqdn,
    document_url        => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#overdue-publications-in-whitehall',
  }
  # END whitehall

  # START datainsight
  $datainsight_base_uri = "https://${http_username}:${http_password}@datainsight-frontend.${app_domain}/performance/dashboard"

  @nagios::plugin { 'check_datainsight_recorder':
    source  => 'puppet:///modules/nagios/usr/lib/nagios/plugins/check_datainsight_recorder.rb',
  }

  nagios::check { 'check_datainsight_hourly_traffic_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/hourly-traffic.json 60",
    host_name           => $::fqdn,
    service_description => 'checks if datainsight endpoint for gov.uk hourly traffic is updated regularly',
  }

  nagios::check { 'check_datainsight_visits_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/visits.json 10080",
    host_name           => $::fqdn,
    service_description => 'checks if datainsight endpoint for gov.uk visits is updated regularly',
  }

  nagios::check { 'check_datainsight_unique_visitors_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/unique-visitors.json 10080",
    host_name           => $::fqdn,
    service_description => 'checks if datainsight endpoint for gov.uk visitors is updated regularly',
  }

  nagios::check { 'check_datainsight_format_success_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/content-engagement.json 10080",
    host_name           => $::fqdn,
    service_description => 'checks if datainsight endpoint for gov.uk content engagement is updated regularly',
  }

  nagios::check { 'check_datainsight_insidegov_weekly_visitors_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/government/visitors/weekly.json 10080",
    host_name           => $::fqdn,
    service_description => 'checks if datainsight endpoint for insidegov visitors is updated regularly',
  }

  nagios::check { 'check_datainsight_insidegov_policies_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/government/most-entered-policies.json 10080",
    host_name           => $::fqdn,
    service_description => 'checks if datainsight endpoint for insidegov most entered policies is updated regularly',
  }

  nagios::check { 'check_datainsight_insidegov_content_engagement_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/government/content-engagement.json 10080",
    host_name           => $::fqdn,
    service_description => 'checks if datainsight endpoint for insidegov content engagement is updated regularly',
  }  # END datainsight

  $warning_time = 5
  $critical_time = 10

  # START backdrop
  $backdrop_read_hostname = "read.backdrop.${app_domain}"
  $backdrop_write_hostname = "write.backdrop.${app_domain}"

  nagios::check { 'check_backdrop_read_endpoint':
    check_command       => "check_https_url!${backdrop_read_hostname}!/_status!${warning_time}!${critical_time}",
    host_name           => $::fqdn,
    service_description => 'checks if backdrop.read endpoint is up',
  }

  nagios::check { 'check_backdrop_write_endpoint':
    check_command       => "check_https_url!${backdrop_write_hostname}!/_status!${warning_time}!${critical_time}",
    host_name           => $::fqdn,
    service_description => 'checks if backdrop.write endpoint is up',
  }

  # END backdrop

  # START limelight
  $limelight_hostname = "limelight.${app_domain}"

  nagios::check { 'check_limelight_endpoint':
    check_command       => "check_https_url!${limelight_hostname}!/_status!${warning_time}!${critical_time}",
    host_name           => $::fqdn,
    service_description => 'checks if limelight homepage is up',
  }

  # END limelight

  nagios::check {'check_mapit_responding':
    check_command       => 'check_mapit',
    host_name           => $::fqdn,
    service_description => 'mapit not responding to postcode query',
  }

  # START ssl certificate checks
  nagios::check { 'check_wildcard_cert_valid':
    check_command       => "check_ssl_cert!signon.${app_domain}!30",
    host_name           => $::fqdn,
    service_description => "check the STAR.${app_domain} SSL certificate is valid and not due to expire",
  }
  # END ssl certificate checks

  # START support
  nagios::check::graphite { 'check_support_default_queue_size':
    target    => 'govuk.app.support.queues.default',
    warning   => 10,
    critical  => 20,
    desc      => 'support app background processing: unexpectedly large default queue size',
  }
  # END support

  nagios::timeperiod { '24x7':
    timeperiod_alias => '24 Hours A Day, 7 Days A Week',
    sun              => '00:00-24:00',
    mon              => '00:00-24:00',
    tue              => '00:00-24:00',
    wed              => '00:00-24:00',
    thu              => '00:00-24:00',
    fri              => '00:00-24:00',
    sat              => '00:00-24:00',
  }

  nagios::timeperiod { 'workhours':
    timeperiod_alias => 'Standard Work Hours',
    mon              => '09:00-17:00',
    tue              => '09:00-17:00',
    wed              => '09:00-17:00',
    thu              => '09:00-17:00',
    fri              => '09:00-17:00',
  }

  nagios::timeperiod { 'nonworkhours':
    timeperiod_alias => 'Non-Work Hours',
    sun              => '00:00-24:00',
    mon              => '00:00-09:00,16:00-24:00',
    tue              => '00:00-09:00,16:00-24:00',
    wed              => '00:00-09:00,16:00-24:00',
    thu              => '00:00-09:00,16:00-24:00',
    fri              => '00:00-09:00,17:00-24:00',
    sat              => '00:00-24:00',
  }

  nagios::timeperiod { 'never':
    timeperiod_alias => 'Never'
  }

  #TODO: extlookup or hiera for email addresses?

  case $::govuk_provider {
    sky: {
      $contact_email = extlookup('monitoring_group', 'root@localhost')
    }
    default: {
      # ugh.
      $contact_email = 'monitoring-ec2preview@digital.cabinet-office.gov.uk'
    }
  }

  nagios::contact { 'monitoring_google_group':
    email => $contact_email
  }

  nagios::contact { 'zendesk_urgent_priority':
    email                        => 'zd-alrt-urgent@digital.cabinet-office.gov.uk',
    service_notification_options => 'c,w',
  }

  nagios::contact { 'zendesk_high_priority':
    email                        => 'zd-alrt-high@digital.cabinet-office.gov.uk',
    service_notification_options => 'c,w',
  }

  nagios::contact { 'zendesk_normal_priority':
    email                        => 'zd-alrt-normal@digital.cabinet-office.gov.uk',
    service_notification_options => 'c,w',
  }

  nagios::pager_contact { 'pager_nonworkhours':
    service_notification_options => 'c',
    notification_period          => '24x7',
  }

  nagios::contact_group { 'regular':
    group_alias => 'Contacts for regular alerts',
    members     => ['monitoring_google_group'],
  }

  # End Zendesk Groups

  nagios::service_template { 'govuk_regular_service':
    contact_groups => ['regular']
  }

  nagios::service_template { 'govuk_urgent_priority':
    contact_groups => ['urgent-priority']
  }

  nagios::service_template { 'govuk_high_priority':
    contact_groups => ['high-priority']
  }

  nagios::service_template { 'govuk_normal_priority':
    contact_groups => ['normal-priority']
  }

  nagios::service_template { 'govuk_low_priority':
    contact_groups => ['regular']
  }

  nagios::service_template { 'govuk_unprio_priority':
    contact_groups => ['regular']
  }

}
