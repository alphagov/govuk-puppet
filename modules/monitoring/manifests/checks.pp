class monitoring::checks {

  include daemontools # provides setlock

  $app_domain = extlookup('app_domain')

  cron { 'cron_smokey_features':
    command => '/usr/bin/setlock -n /var/run/smokey.lock /opt/smokey/cron_json.sh /tmp/smokey.json',
    minute  => '*',
  }

  nagios::check_feature {
    'check_businesssupportfinder':  feature => 'businesssupportfinder';
    'check_calendars':              feature => 'calendars';
    'check_contractsfinder':        feature => 'contractsfinder';
    'check_efg':                    feature => 'efg';
    'check_frontend':               feature => 'frontend';
    'check_licencefinder':          feature => 'licencefinder';
    'check_licensing':              feature => 'licensing';
    'check_publishing':             feature => 'mainstream_publishing_tools';
    'check_router':                 feature => 'router';
    'check_search':                 feature => 'search';
    'check_smartanswers':           feature => 'smartanswers';
    'check_signon':                 feature => 'signon';
    'check_tariff':                 feature => 'tariff';
    'check_whitehall':              feature => 'whitehall';
  }

  @@nagios::check { 'check_pingdom':
    check_command       => 'run_pingdom_homepage_check',
    use                 => 'govuk_urgent_priority',
    service_description => 'Pingdom homepage check',
    host_name           => $::fqdn,
  }

  @@nagios::check { 'check_pingdom_calendar':
    check_command       => 'run_pingdom_calendar_check',
    use                 => 'govuk_high_priority',
    service_description => 'Pingdom calendar check',
    host_name           => $::fqdn,
  }

  @@nagios::check { 'check_pingdom_search':
    check_command       => 'run_pingdom_search_check',
    use                 => 'govuk_urgent_priority',
    service_description => 'Pingdom search check',
    host_name           => $::fqdn,
  }

  @@nagios::check { 'check_pingdom_smart_answer':
    check_command       => 'run_pingdom_smart_answer_check',
    use                 => 'govuk_high_priority',
    service_description => 'Pingdom smartanswers check',
    host_name           => $::fqdn,
  }

  @@nagios::check { 'check_pingdom_specialist':
    check_command       => 'run_pingdom_specialist_check',
    use                 => 'govuk_high_priority',
    service_description => 'Pingdom specialist guides check',
    host_name           => $::fqdn,
  }

  # START frontend
  @@nagios::check { "check_frontend_to_exit_404_rejects":
    check_command       => 'check_graphite_metric_since!hitcount(sumSeries(stats.govuk.app.frontend.*.request.exit.404),\'5minutes\')!5minutes!50!100',
    use                 => 'govuk_normal_priority',
    service_description => 'check volume of 404 rejects for exit links',
    host_name           => $::fqdn,
  }
  # END frontend

  # START whitehall
  @@nagios::check { "check_whitehall_overdue_from_${::hostname}":
    check_command       => 'check_whitehall_overdue',
    service_description => 'overdue publications in Whitehall',
    use                 => 'govuk_urgent_priority',
    host_name           => $::fqdn,
  }
  # END whitehall

  # START datainsight
  $http_username = extlookup('http_username', 'UNSET')
  $http_password = extlookup('http_password', 'UNSET')
  $datainsight_base_uri = "https://${http_username}:${http_password}@datainsight-frontend.${app_domain}/performance/dashboard"

  @nagios::plugin { 'check_datainsight_recorder':
    source  => 'puppet:///modules/nagios/usr/lib/nagios/plugins/check_datainsight_recorder.rb',
  }

  @@nagios::check { 'check_datainsight_hourly_traffic_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/hourly-traffic.json 60",
    use                 => 'govuk_normal_priority',
    service_description => 'checks if datainsight endpoint for gov.uk hourly traffic is updated regularly',
    host_name           => $::fqdn,
  }

  @@nagios::check { 'check_datainsight_visits_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/visits.json 10080",
    use                 => 'govuk_normal_priority',
    service_description => 'checks if datainsight endpoint for gov.uk visits is updated regularly',
    host_name           => $::fqdn,
  }

  @@nagios::check { 'check_datainsight_unique_visitors_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/unique-visitors.json 10080",
    use                 => 'govuk_normal_priority',
    service_description => 'checks if datainsight endpoint for gov.uk visitors is updated regularly',
    host_name           => $::fqdn,
  }

  @@nagios::check { 'check_datainsight_format_success_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/content-engagement.json 10080",
    use                 => 'govuk_normal_priority',
    service_description => 'checks if datainsight endpoint for gov.uk content engagement is updated regularly',
    host_name           => $::fqdn,
  }

  @@nagios::check { 'check_datainsight_insidegov_weekly_visitors_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/government/visitors/weekly.json 10080",
    use                 => 'govuk_normal_priority',
    service_description => 'checks if datainsight endpoint for insidegov visitors is updated regularly',
    host_name           => $::fqdn,
  }

  @@nagios::check { 'check_datainsight_insidegov_policies_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/government/most-entered-policies.json 10080",
    use                 => 'govuk_normal_priority',
    service_description => 'checks if datainsight endpoint for insidegov most entered policies is updated regularly',
    host_name           => $::fqdn,
  }

  @@nagios::check { 'check_datainsight_insidegov_content_engagement_endpoint':
    check_command       => "check_nrpe!check_datainsight_recorder!${datainsight_base_uri}/government/content-engagement.json 10080",
    use                 => 'govuk_normal_priority',
    service_description => 'checks if datainsight endpoint for insidegov content engagement is updated regularly',
    host_name           => $::fqdn,
  }  # END datainsight

  @nagios::plugin { 'check_performance_platform':
    source  => 'puppet:///modules/performance_platform/check_performance_platform.cfg',
  }

  # START backdrop
  $http_username = extlookup('http_username', 'UNSET')
  $http_password = extlookup('http_password', 'UNSET')
  $backdrop_read_base_uri = "https://${http_username}:${http_password}@read.backdrop.${app_domain}"

  @@nagios::check { 'check_backdrop_read_endpoint':
    check_command       => "check_nrpe!check_performance_platform!health_check ${backdrop_read_base_uri}/_status $http_username $http_password",
    use                 => 'govuk_normal_priority',
    service_description => 'checks if backdrop.read endpoint is up',
    host_name           => $::fqdn,
  }

  # END backdrop

  # START limelight
  $http_username = extlookup('http_username', 'UNSET')
  $http_password = extlookup('http_password', 'UNSET')
  $limelight_base_uri = "https://${http_username}:${http_password}@limelight.${app_domain}"

  @@nagios::check { 'check_limelight_endpoint':
    check_command       => "check_nrpe!check_performance_platform!health_check ${limelight_base_uri}/_status $http_username $http_password",
    use                 => 'govuk_normal_priority',
    service_description => 'checks if limelight homepage is up',
    host_name           => $::fqdn,
  }

  # END limelight

  @@nagios::check {'check_mapit_responding':
    check_command       => "check_mapit",
    use                 => 'govuk_normal_priority',
    service_description => 'mapit not responding to postcode query',
    host_name           => $::fqdn,
  }

  # START ssl certificate checks
  nagios::check { 'check_wildcard_cert_valid':
    check_command       => "check_ssl_cert!signon.${app_domain}!30",
    use                 => 'govuk_normal_priority',
    service_description => "check the STAR.${app_domain} SSL certificate is valid and not due to expire",
    host_name           => $::fqdn,
  }
  # END ssl certificate checks

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
