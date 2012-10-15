class nagios::config ($platform = $::govuk_platform) {

  include govuk::htpasswd

  $domain = $platform ? {
    'development' => 'dev.gov.uk',
    default       => "${platform}.alphagov.co.uk",
  }

  $vhost = "nagios.${domain}"

  nginx::config::ssl { $vhost: certtype => 'wildcard_alphagov' }
  nginx::config::site { $vhost:
    content => template('nagios/nginx.conf.erb'),
  }

  file { '/etc/nagios3':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/nagios/etc/nagios3',
  }

  file { '/etc/nagios3/conf.d':
    ensure  => directory,
    purge   => true,
    force   => true,
    recurse => true,
    source  => 'puppet:///modules/nagios/etc/nagios3/conf.d',
  }

  file { '/etc/nagios3/conf.d/check_graphite.cfg':
    content => template('nagios/etc/nagios3/conf.d/check_graphite.cfg.erb'),
  }

  file { '/etc/nagios3/conf.d/check_graphite_metric_since.cfg':
    content => template('nagios/etc/nagios3/conf.d/check_graphite_metric_since.cfg.erb'),
  }

  cron { 'cron_smokey_features':
    command => '/opt/smokey/cron.sh',
    # Every 5 minutes
    minute => '*/5',
  }

  nagios::check_feature {
    'check_apollo':                 feature => 'apollo';
    'check_businesssupportfinder':  feature => 'businesssupportfinder';
    'check_cache':                  feature => 'cache';
    'check_calendars':              feature => 'calendars';
    'check_contractsfinder':        feature => 'contractsfinder';
    'check_efg':                    feature => 'efg';
    'check_elasticsearch':          feature => 'elasticsearch';
    'check_frontend':               feature => 'frontend';
    'check_licencefinder':          feature => 'licencefinder';
    'check_mongo':                  feature => 'mongo';
    'check_mysql':                  feature => 'mysql';
    'check_publishing':             feature => 'mainstream_publishing_tools';
    'check_router':                 feature => 'router';
    'check_search':                 feature => 'search';
    'check_smartanswers':           feature => 'smartanswers';
    'check_signon':                 feature => 'signon';
    'check_solr':                   feature => 'solr';
    'check_tariff':                 feature => 'tariff';
    'check_whitehall':              feature => 'whitehall';
  }

  @@nagios::check { 'check_pingdom':
    check_command       => 'run_pingdom_homepage_check',
    use                 => 'govuk_urgent_priority',
    service_description => 'pingdom says gov.uk is down',
    host_name           => "${::govuk_class}-${::hostname}"
  }

  @@nagios::check { 'check_pingdom_calendar':
    check_command       => 'run_pingdom_calendar_check',
    use                 => 'govuk_high_priority',
    service_description => 'pingdom says calendar is down',
    host_name           => "${::govuk_class}-${::hostname}"
  }

  @@nagios::check { 'check_pingdom_quick_answer':
    check_command       => 'run_pingdom_quick_answer_check',
    use                 => 'govuk_urgent_priority',
    service_description => 'pingdom says quick answer is down',
    host_name           => "${::govuk_class}-${::hostname}"
  }

  @@nagios::check { 'check_pingdom_search':
    check_command       => 'run_pingdom_search_check',
    use                 => 'govuk_urgent_priority',
    service_description => 'pingdom says search is down',
    host_name           => "${::govuk_class}-${::hostname}"
  }

  @@nagios::check { 'check_pingdom_smart_answer':
    check_command       => 'run_pingdom_smart_answer_check',
    use                 => 'govuk_high_priority',
    service_description => 'pingdown say smartanswers is down',
    host_name           => "${::govuk_class}-${::hostname}"
  }

  @@nagios::check { 'check_pingdom_specialist':
    check_command       => 'run_pingdom_specialist_check',
    use                 => 'govuk_high_priority',
    service_description => 'pingdom says specialist guides is down',
    host_name           => "${::govuk_class}-${::hostname}"
  }

  # BEGIN imminence checks
  @@nagios::check { "check_imminence_admin_responsiveness_${::hostname}":
    check_command       => 'check_graphite_metric!maxSeries(stats.govuk.app.imminence.*.response_time.admin.*.*.upper_90)!500!1000',
    use                 => 'govuk_normal_priority',
    service_description => 'imminence admin unresponsive',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_imminence_api_responsiveness_${::hostname}":
    check_command       => 'check_graphite_metric!maxSeries(stats.govuk.app.imminence.*.response_time.api.*.*.upper_90)!500!1000',
    use                 => 'govuk_high_priority',
    service_description => 'imminence api unresponsive',
    host_name           => "${::govuk_class}-${::hostname}",
  }
  # END imminence

  # START contentapi
  @@nagios::check { "check_contentapi_responsiveness":
    check_command       => 'check_graphite_metric!maxSeries(stats.timers.govuk.app.contentapi.*.request.artefact.upper_90)!500!1000',
    use                 => 'govuk_normal_priority',
    service_description => 'contentapi unresponsive',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_contentapi_licensify_http_errors":
    check_command       => 'check_graphite_metric!sumSeries(stats.govuk.app.contentapi.*.request.artefact.license_request_error.http)!5!10',
    use                 => 'govuk_normal_priority',
    service_description => 'http errors from contentapi to licensify',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  # END contentapi

  # BEGIN signon checks
  @@nagios::check { "check_signon_login_failures":
    check_command       => 'check_graphite_metric!sumSeries(stats.govuk.app.signon.*.logins.failure)!5!10',
    use                 => 'govuk_normal_priority',
    service_description => 'signon login failures too high',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_signon_accounts_suspended":
    check_command       => 'check_graphite_metric!sumSeries(stats.govuk.app.signon.*.users.suspend)!1!2',
    use                 => 'govuk_normal_priority',
    service_description => 'signon user suspensions too high',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_signon_accounts_created":
    check_command       => 'check_graphite_metric!sumSeries(stats.govuk.app.signon.*.users.created)!1!2',
    use                 => 'govuk_normal_priority',
    service_description => 'signon user creation too high',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_signon_password_reset_requests":
    check_command       => 'check_graphite_metric!sumSeries(stats.govuk.app.signon.*.users.password_reset_request)!1!2',
    use                 => 'govuk_normal_priority',
    service_description => 'signon password resets too high',
    host_name           => "${::govuk_class}-${::hostname}",
  }
  # END signon checks

  # START frontend
  @@nagios::check { "check_frontend_to_contentapi_responsiveness":
    check_command       => 'check_graphite_metric!maxSeries(stats.govuk.app.frontend.*.request.id.*)!500!1000',
    use                 => 'govuk_normal_priority',
    service_description => 'contentapi unresponsive from frontend',
    host_name           => "${::govuk_class}-${::hostname}",
  }
  # END frontend

  # START rummager
  @@nagios::check { "check_rummager_to_elasticsearch_errors":
    check_command       => 'check_graphite_metric!sumSeries(stats.govuk.app.search.*.elasticsearcherror)!5!10',
    use                 => 'govuk_high_priority',
    service_description => 'search errors from rummager too high',
    host_name           => "${::govuk_class}-${::hostname}",
  }
  # END rummager
  # Start Whitehall
    @@nagios::check { "check_scheduled_publishing_${::hostname}":
      check_command       => "check_graphite_metric_since!hitcount(stats.govuk.app.whitehall.scheduled_publishing.call_rate,'16minutes')!16minutes!0.9:100!0.9:100",
      service_description => 'whitehall sched pub not run in prev 16m',
      use                 => 'govuk_urgent_priority',
      host_name           => "${::govuk_class}-${::hostname}",
    }

    @@nagios::check { "check_no_overdue_scheduled_editions_${::hostname}":
      check_command       => "check_graphite_metric!stats.gauges.govuk.app.whitehall.scheduled_publishing.due!0!0",
      service_description => 'whitehall has overdue scheduled editions',
      use                 => 'govuk_urgent_priority',
      host_name           => "${::govuk_class}-${::hostname}",
    }

  # END Whitehall

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
      $contact_email = $::govuk_platform ? {
        production   => 'monitoring-ec2production@digital.cabinet-office.gov.uk',
        preview      => 'monitoring-ec2preview@digital.cabinet-office.gov.uk',
        default      => 'root@localhost',
      }
    }
  }

  nagios::contact { 'monitoring_google_group':
    email => $contact_email
  }

  nagios::contact { 'zendesk_urgent_priority':
    email                        => 'zd-alrt-urgent@digital.cabinet-office.gov.uk',
    service_notification_options => 'c,w,u',
  }

  nagios::contact { 'zendesk_high_priority':
    email                        => 'zd-alrt-high@digital.cabinet-office.gov.uk',
    service_notification_options => 'c,w,u',
  }

  nagios::contact { 'zendesk_normal_priority':
    email                        => 'zd-alrt-normal@digital.cabinet-office.gov.uk',
    service_notification_options => 'c,w,u',
  }

  nagios::pager_contact { 'pager_nonworkhours':
    service_notification_options => 'c',
    notification_period          => 'nonworkhours',
  }

  nagios::contact_group { 'regular':
    group_alias => 'Contacts for regular alerts',
    members     => ['monitoring_google_group'],
  }

  # The next three contact groups include Zendesk for production

  case $::govuk_platform {
    production: {
      case $::govuk_provider {
        sky: {
          $urgentprio_members = ['monitoring_google_group','pager_nonworkhours', 'zendesk_urgent_priority']
          $highprio_members  = ['monitoring_google_group','zendesk_high_priority']
          $normalprio_members  = ['monitoring_google_group','zendesk_normal_priority']
        }
        default: {
          $urgentprio_members = ['monitoring_google_group']
          $highprio_members  = $urgentprio_members
          $normalprio_members  = $urgentprio_members
        }
      }
    }
    default: {
      $urgentprio_members = ['monitoring_google_group']
      $highprio_members  = $urgentprio_members
      $normalprio_members  = $urgentprio_members
    }
  }

  nagios::contact_group { 'urgent-priority':
    group_alias => 'Contacts for urgent priority alerts',
    members     => $urgentprio_members,
  }

  nagios::contact_group { 'high-priority':
    group_alias => 'Contacts for high priority alerts',
    members     => $highprio_members,
  }

  nagios::contact_group { 'normal-priority':
    group_alias => 'Contacts for normal priority alerts',
    members     => $normalprio_members,
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

  $monitoring_url = $::govuk_platform ? {
    production    => 'https://nagios.production.alphagov.co.uk/',
    preview       => 'https://nagios.preview.alphagov.co.uk/',
    default       => 'http://localhost/nagios3/',
  }

  file { '/etc/nagios3/resource.cfg':
    content  => template('nagios/resource.cfg.erb'),
  }

  cron { 'pagerduty':
    command => '/usr/local/bin/pagerduty_nagios.pl flush',
    user    => 'nagios',
    minute  => '*',
  }

  user { 'www-data':
    groups => ['nagios'],
  }

}
