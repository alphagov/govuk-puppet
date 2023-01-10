# == Class: govuk::apps::content_data_api::amazonmq_monitoring
#
# Defines the checks to be performed against the AmazonMQ queues
# for content_data_api
#
# === Parameters
#
class govuk::apps::content_data_api::amazonmq_monitoring {

  govuk_amazonmq::monitor_consumers { "content_data_api_govuk_importer_consumer_monitoring":
    queue_name          => 'content_data_api_govuk_importer',
    ensure              =>  present,
  }

}
