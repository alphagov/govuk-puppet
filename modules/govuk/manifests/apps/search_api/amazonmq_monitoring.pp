# == Class: govuk::apps::search_api::amazonmq_monitoring
#
# Defines the checks to be performed against the AmazonMQ queues
# for search_api
#
# === Parameters
#
class govuk::apps::search_api::amazonmq_monitoring (
  $region = 'eu-west-1'
) {
  
  icinga::check { "check_amazonmq_consumers_for_search_api_to_be_indexed_on_${::hostname}":
    check_command       => "check_amazonmq_consumers!PublishingMQ!publishing!search_api_to_be_indexed!${region}",
    service_description => "Check 5-min avg consumer count for publishing AmazonMQ queue search_api_to_be_indexed",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
  }

  icinga::check { "check_rabbitmq_messages_for_search_api_to_be_indexed_on_${::hostname}":
    check_command       => "check_amazonmq_messages!PublishingMQ!publishing!search_api_to_be_indexed!${region}!${critical_threshold}!${warning_threshold}",
    service_description => "Check that messages are being processed in publishing AmazonMQ queue search_api_to_be_indexed",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(rabbitmq-high-number-of-unprocessed-messages),
  }

  icinga::check { "check_amazonmq_consumers_for_search_api_govuk_index_on_${::hostname}":
    check_command       => "check_amazonmq_consumers!PublishingMQ!publishing!search_api_govuk_index!${region}",
    service_description => "Check 5-min avg consumer count for publishing AmazonMQ queue search_api_govuk_index",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
  }

  icinga::check { "check_rabbitmq_messages_for_search_api_govuk_index_on_${::hostname}":
    check_command       => "check_amazonmq_messages!PublishingMQ!publishing!search_api_govuk_index!${region}!${critical_threshold}!${warning_threshold}",
    service_description => "Check that messages are being processed in publishing AmazonMQ queue search_api_govuk_index",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(rabbitmq-high-number-of-unprocessed-messages),
  }

  icinga::check { "check_amazonmq_consumers_for_search_api_bulk_reindex_on_${::hostname}":
    check_command       => "check_amazonmq_consumers!PublishingMQ!publishing!search_api_bulk_reindex!${region}",
    service_description => "Check 5-min avg consumer count for publishing AmazonMQ queue search_api_bulk_reindex",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
  }

  icinga::check { "check_rabbitmq_messages_for_search_api_bulk_reindex_on_${::hostname}":
    check_command       => "check_amazonmq_messages!PublishingMQ!publishing!search_api_bulk_reindex!${region}!${critical_threshold}!${warning_threshold}",
    service_description => "Check that messages are being processed in publishing AmazonMQ queue search_api_bulk_reindex",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(rabbitmq-high-number-of-unprocessed-messages),
  }
}
