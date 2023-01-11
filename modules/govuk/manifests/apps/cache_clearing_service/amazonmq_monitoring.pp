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
  govuk_amazonmq::monitor_consumers { 'cache_clearing_service-high_consumer_monitoring':
    ensure     => present,
    queue_name => 'cache_clearing_service-high',
  }

  govuk_amazonmq::monitor_consumers { 'cache_clearing_service-medium_consumer_monitoring':
    ensure     => present,
    queue_name => 'cache_clearing_service-medium',
  }

  govuk_amazonmq::monitor_consumers { 'cache_clearing_service-low_consumer_monitoring':
    ensure     => present,
    queue_name => 'cache_clearing_service-low',
  }

  # Message counts
  govuk_amazonmq::monitor_messages { 'cache_clearing_service-high_message_monitoring':
    ensure             => present,
    queue_name         => 'cache_clearing_service-high',
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
  }

  govuk_amazonmq::monitor_messages { 'cache_clearing_service-medium_message_monitoring':
    ensure             => present,
    queue_name         => 'cache_clearing_service-medium',
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
  }

  govuk_amazonmq::monitor_messages { 'cache_clearing_service-low_message_monitoring':
    ensure             => present,
    queue_name         => 'cache_clearing_service-low',
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
  }
}
