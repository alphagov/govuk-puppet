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
  icinga::check { "check_amazonmq_consumers_for_email_alert_service_on_${::hostname}":
    check_command       => "check_amazonmq_consumers!PublishingMQ!publishing!email_alert_service!${region}",
    service_description => "Check 5-min avg consumer count for publishing AmazonMQ queue email_alert_service",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
  }

  icinga::check { "check_amazonmq_consumers_for_email_unpublishing_on_${::hostname}":
    check_command       => "check_amazonmq_consumers!PublishingMQ!publishing!email_unpublishing!${region}",
    service_description => "Check 5-min avg consumer count for publishing AmazonMQ queue email_unpublishing",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
  }

  icinga::check { "check_amazonmq_consumers_for_subscriber_list_details_update_major_on_${::hostname}":
    check_command       => "check_amazonmq_consumers!PublishingMQ!publishing!subscriber_list_details_update_major!${region}",
    service_description => "Check 5-min avg consumer count for publishing AmazonMQ queue subscriber_list_details_update_major",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
  }

  icinga::check { "check_amazonmq_consumers_for_subscriber_list_details_update_minor_on_${::hostname}":
    check_command       => "check_amazonmq_consumers!PublishingMQ!publishing!subscriber_list_details_update_minor!${region}",
    service_description => "Check 5-min avg consumer count for publishing AmazonMQ queue subscriber_list_details_update_minor",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
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
