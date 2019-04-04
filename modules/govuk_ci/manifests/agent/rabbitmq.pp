# == Class: govuk_ci::agent::rabbitmq
#
# Installs and configures rabbitmq-server
#
class govuk_ci::agent::rabbitmq {
  contain ::govuk_rabbitmq

  rabbitmq_user {
    'email_alert_service_test':
      password => 'email_alert_service_test';
    'govuk_seed_crawler':
      password => 'govuk_seed_crawler';
    'govuk_crawler_worker':
      password => 'govuk_crawler_worker',
      tags     => ['monitoring'];
    'publishing_api':
      password => 'publishing_api';
  }

  rabbitmq_user_permissions {
    'email_alert_service_test@/':
      configure_permission => '^(amq\.gen.*|email_alert_service_published_documents_test_exchange|email_alert_service_published_documents_test_queue|email_alert_service_unpublishing_documents_test_queue|email_alert_service_workflow_test_queue)$',
      read_permission      => '^(amq\.gen.*|email_alert_service_published_documents_test_exchange|email_alert_service_published_documents_test_queue|email_alert_service_unpublishing_documents_test_queue|email_alert_service_workflow_test_queue)$',
      write_permission     => '^(amq\.gen.*|email_alert_service_published_documents_test_exchange|email_alert_service_published_documents_test_queue|email_alert_service_unpublishing_documents_test_queue|email_alert_service_workflow_test_queue)$';
    'govuk_seed_crawler@/':
      configure_permission => '^govuk_seed_crawler.*',
      read_permission      => '^govuk_seed_crawler.*',
      write_permission     => '^govuk_seed_crawler.*';
    'govuk_crawler_worker@/':
      configure_permission => '^govuk_crawler_worker.*',
      read_permission      => '^govuk_crawler_worker.*',
      write_permission     => '^govuk_crawler_worker.*';
    'publishing_api@/':
      configure_permission => '^amq\.gen.*$',
      read_permission      => '^(amq\.gen.*|published_documents_test)$',
      write_permission     => '^(amq\.gen.*|published_documents_test)$';
  }

  govuk_rabbitmq::exchange {
    [
      'email_alert_service_published_documents_test_exchange@/',
      'published_documents_test@/',
    ]:
      type     => 'topic';
  }

}
