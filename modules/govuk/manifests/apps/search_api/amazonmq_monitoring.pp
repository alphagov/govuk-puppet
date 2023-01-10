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
  
  govuk_amazonmq::monitor_consumers { "search_api_to_be_indexed_consumer_monitoring":
    queue_name          => 'search_api_to_be_indexed',
    ensure              =>  present,
  }

  govuk_amazonmq::monitor_consumers { "search_api_govuk_index_consumer_monitoring":
    queue_name          => 'search_api_govuk_index',
    ensure              =>  present,
  }

  govuk_amazonmq::monitor_consumers { "search_api_bulk_reindex_consumer_monitoring":
    queue_name          => 'search_api_bulk_reindex',
    ensure              =>  present,
  }

}
