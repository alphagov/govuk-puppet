# == Class: govuk::apps::email_alert_service::amazonmq_monitoring
#
# Defines the checks to be performed against the AmazonMQ queues
# for email_alert_service
#
# === Parameters
#
class govuk::apps::email_alert_service::amazonmq_monitoring (
  $region = 'eu-west-1',
  $queue_size_critical_threshold,
  $queue_size_warning_threshold,
) {
  
  # Consumer counts
  govuk_amazonmq::monitor_consumers { "email_alert_service_consumer_monitoring":
    queue_name          => 'email_alert_service',
    ensure              =>  present,
  }

  govuk_amazonmq::monitor_consumers { "email_unpublishing_consumer_monitoring":
    queue_name          => 'email_unpublishing',
    ensure              =>  present,
  }

  govuk_amazonmq::monitor_consumers { "subscriber_list_details_update_major_consumer_monitoring":
    queue_name          => 'subscriber_list_details_update_major',
    ensure              =>  present,
  }

  govuk_amazonmq::monitor_consumers { "subscriber_list_details_update_minor_consumer_monitoring":
    queue_name          => 'subscriber_list_details_update_minor',
    ensure              =>  present,
  }



  # Message counts
  icinga::check { "check_amazonmq_messages_for_email_alert_service${::hostname}":
    check_command       => "check_amazonmq_messages!PublishingMQ!publishing!email_alert_service!${region}!${queue_size_critical_threshold}!${queue_size_warning_threshold}",
    service_description => "Check that messages are being processed in publishing AmazonMQ queue email_alert_service",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-high-number-of-unprocessed-messages),
  }

  icinga::check { "check_amazonmq_messages_for_email_unpublishing${::hostname}":
    check_command       => "check_amazonmq_messages!PublishingMQ!publishing!email_unpublishing!${region}!${queue_size_critical_threshold}!${queue_size_warning_threshold}",
    service_description => "Check that messages are being processed in publishing AmazonMQ queue email_unpublishing",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-high-number-of-unprocessed-messages),
  }

  icinga::check { "check_amazonmq_messages_for_subscriber_list_details_update_major${::hostname}":
    check_command       => "check_amazonmq_messages!PublishingMQ!publishing!subscriber_list_details_update_major!${region}!${queue_size_critical_threshold}!${queue_size_warning_threshold}",
    service_description => "Check that messages are being processed in publishing AmazonMQ queue subscriber_list_details_update_major",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-high-number-of-unprocessed-messages),
  }

  icinga::check { "check_amazonmq_messages_for_subscriber_list_details_update_minor${::hostname}":
    check_command       => "check_amazonmq_messages!PublishingMQ!publishing!subscriber_list_details_update_minor!${region}!${queue_size_critical_threshold}!${queue_size_warning_threshold}",
    service_description => "Check that messages are being processed in publishing AmazonMQ queue subscriber_list_details_update_minor",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-high-number-of-unprocessed-messages),
  }
}
