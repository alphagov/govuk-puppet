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
  govuk_amazonmq::monitor_consumers { "cache_clearing_service-high_consumer_monitoring":
    queue_name          => 'cache_clearing_service-high',
    ensure              =>  present,
  }

  govuk_amazonmq::monitor_consumers { "cache_clearing_service-medium_consumer_monitoring":
    queue_name          => 'cache_clearing_service-medium',
    ensure              =>  present,
  }

  govuk_amazonmq::monitor_consumers { "cache_clearing_service-low_consumer_monitoring":
    queue_name          => 'cache_clearing_service-low',
    ensure              =>  present,
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
