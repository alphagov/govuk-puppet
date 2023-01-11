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

  govuk_amazonmq::monitor_consumers { 'account_api_consumer_monitoring':
    ensure     =>  present,
    queue_name => 'account_api',
  }

}
