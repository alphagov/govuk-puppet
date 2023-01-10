# == Class: govuk::apps::cache_clearing_service::amazonmq_monitoring
#
# Defines the checks to be performed against the AmazonMQ queues
# for cache_clearing_service
#
# === Parameters
#
class govuk::apps::cache_clearing_service::amazonmq_monitoring (
  $region = 'eu-west-1',
  $queue_size_critical_threshold,
  $queue_size_warning_threshold,
) {
  
  # Consumer counts
  icinga::check { "check_amazonmq_consumers_for_cache_clearing_service-high${::hostname}":
    check_command       => "check_amazonmq_consumers!PublishingMQ!publishing!cache_clearing_service-high!${region}",
    service_description => "Check 5-min avg consumer count for publishing AmazonMQ queue cache_clearing_service-high",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
  }

  icinga::check { "check_amazonmq_consumers_for_cache_clearing_service-medium${::hostname}":
    check_command       => "check_amazonmq_consumers!PublishingMQ!publishing!cache_clearing_service-medium!${region}",
    service_description => "Check 5-min avg consumer count for publishing AmazonMQ queue cache_clearing_service-medium",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
  }

  icinga::check { "check_amazonmq_consumers_for_cache_clearing_service-low${::hostname}":
    check_command       => "check_amazonmq_consumers!PublishingMQ!publishing!cache_clearing_service-low!${region}",
    service_description => "Check 5-min avg consumer count for publishing AmazonMQ queue cache_clearing_service-low",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
  }

  # Message counts
  icinga::check { "check_amazonmq_messages_for_cache_clearing_service-high${::hostname}":
    check_command       => "check_amazonmq_messages!PublishingMQ!publishing!cache_clearing_service-high!${region}!${queue_size_critical_threshold}!${queue_size_warning_threshold}",
    service_description => "Check that messages are being processed in publishing AmazonMQ queue cache_clearing_service-high",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-high-number-of-unprocessed-messages),
  }

  icinga::check { "check_amazonmq_messages_for_cache_clearing_service-medium${::hostname}":
    check_command       => "check_amazonmq_messages!PublishingMQ!publishing!cache_clearing_service-medium!${region}!${queue_size_critical_threshold}!${queue_size_warning_threshold}",
    service_description => "Check that messages are being processed in publishing AmazonMQ queue cache_clearing_service-medium",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-high-number-of-unprocessed-messages),
  }

  icinga::check { "check_amazonmq_messages_for_cache_clearing_service-low${::hostname}":
    check_command       => "check_amazonmq_messages!PublishingMQ!publishing!cache_clearing_service-low!${region}!${queue_size_critical_threshold}!${queue_size_warning_threshold}",
    service_description => "Check that messages are being processed in publishing AmazonMQ queue cache_clearing_service-low",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-high-number-of-unprocessed-messages),
  }
}
