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
  govuk_amazonmq::monitor_consumers { 'email_alert_service_consumer_monitoring':
    ensure     => present,
    queue_name => 'email_alert_service',
  }

  govuk_amazonmq::monitor_consumers { 'email_unpublishing_consumer_monitoring':
    ensure     => present,
    queue_name => 'email_unpublishing',
  }

  govuk_amazonmq::monitor_consumers { 'subscriber_list_details_update_major_consumer_monitoring':
    ensure     => present,
    queue_name => 'subscriber_list_details_update_major',
  }

  govuk_amazonmq::monitor_consumers { 'subscriber_list_details_update_minor_consumer_monitoring':
    ensure     => present,
    queue_name => 'subscriber_list_details_update_minor',
  }

  # Message counts
  govuk_amazonmq::monitor_messages { 'email_alert_service_messages_monitoring':
    ensure             => present,
    queue_name         => 'email_alert_service',
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
  }

  govuk_amazonmq::monitor_messages { 'email_unpublishing_messages_monitoring':
    ensure             => present,
    queue_name         => 'email_unpublishing',
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
  }

  govuk_amazonmq::monitor_messages { 'subscriber_list_details_update_major_messages_monitoring':
    ensure             => present,
    queue_name         => 'subscriber_list_details_update_major',
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
  }

  govuk_amazonmq::monitor_messages { 'subscriber_list_details_update_minor_messages_monitoring':
    ensure             => present,
    queue_name         => 'subscriber_list_details_update_minor',
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
  }
}
