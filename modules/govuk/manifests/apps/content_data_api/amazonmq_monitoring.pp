# == Class: govuk::apps::content_data_api::amazonmq_monitoring
#
# Defines the checks to be performed against the AmazonMQ queues
# for content_data_api
#
# === Parameters
#
class govuk::apps::content_data_api::amazonmq_monitoring (
  $region = 'eu-west-1'
) {
  
  icinga::check { "check_amazonmq_consumers_for_content_data_api_govuk_importer_on_${::hostname}":
    check_command       => "check_amazonmq_consumers!PublishingMQ!publishing!content_data_api_govuk_importer!${region}",
    service_description => "Check 5-min avg consumer count for publishing AmazonMQ queue content_data_api_govuk_importer",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
  }

  icinga::check { "check_amazonmq_consumers_for_content_data_api_dead_letter_queue_on_${::hostname}":
    check_command       => "check_amazonmq_consumers!PublishingMQ!publishing!content_data_api_dead_letter_queue!${region}",
    service_description => "Check 5-min avg consumer count for publishing AmazonMQ queue content_data_api_dead_letter_queue",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
  }

}
