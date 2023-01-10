# == Class: govuk::apps::account_api::amazonmq_monitoring
#
# Defines the checks to be performed against the AmazonMQ queues
# for account_api
#
# === Parameters
#
class govuk::apps::account_api::amazonmq_monitoring (
  $region = 'eu-west-1'
) {
  
  icinga::check { "check_amazonmq_consumers_for_account_api_on_${::hostname}":
    check_command       => "check_amazonmq_consumers!PublishingMQ!publishing!account_api!${region}",
    service_description => "Check 5-min avg consumer count for publishing AmazonMQ queue account_api",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
  }

}
