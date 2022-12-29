# == Class govuk::apps::search_api
#
# The main search application
#
# === Parameters
#
# [*port*]
#   The port the app will listen on.
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker service.
#   Default: true
#
# [*enable_govuk_index_listener*]
#   Whether to enable the procfile worker service for the govuk index.
#   Default: false
#
# [*enable_bulk_reindex_listener*]
#   Whether or not to configure the queue for the bulk indexer
#
# [*enable_publishing_listener*]
#   Whether to enable the procfile indexing service.
#   Default: false
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*email_alert_api_bearer_token*]
#   The bearer token to use when communicating with Email Alert API.
#   Default: undef
#
# [*rabbitmq_hosts*]
#   RabbitMQ hosts to connect to.
#   Default: localhost
#
# [*rabbitmq_url*]
#   RabbitMQ URL, including username and password.
#   Default: ''
#
# [*rabbitmq_user*]
#   RabbitMQ username.
#   This is a required parameter
#
# [*rabbitmq_password*]
#   RabbitMQ password.
#   Default: search-api
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
# [*google_client_email*]
#   Google authentication email
#   Default: undef
#
# [*google_private_key*]
#   Google authentication private key
#   Default: undef
#
# [*google_analytics_govuk_view_id*]
#   The view id of GOV.UK in Google Analytics
#   Default: undef
#
# [*google_bigquery_credentials*]
#   The credentials to use to fetch data from BigQuery
#   Default: undef
#
# [*spelling_dependencies*]
#   Install the spelling package dependencies
#
# [*unicorn_worker_processes*]
#   The number of unicorn workers to run for an instance of this app
#
# [*oauth_id*]
#   The OAuth ID used by GDS-SSO to identify the app to GOV.UK Signon
#
# [*oauth_secret*]
#   The OAuth secret used by GDS-SSO to authenticate the app to GOV.UK Signon
#
# [*aws_region*]
#   The AWS region of the S3 bucket.
#   Default: eu-west-1
#
# [*relevancy_bucket_name*]
#   The S3 bucket for search relevancy data - e.g. relevancy judgements
#
# [*sitemaps_bucket_name*]
#   The S3 bucket to serve sitemaps from and store them in
#
# [*enable_learning_to_rank*]
#   A feature flag to enable learning to rank in an environment.
#
# [*tensorflow_sagemaker_endpoint*]
#   The Amazon SageMaker endpoint serving the tensorflow model.
#
# [*tensorflow_sagemaker_variants*]
#   Comma-separated list of SageMaker model variants.
#
# [*unicorn_timeout*]
#   Unicorn worker request timeout. Should match search machine Nginx timeout.
#

class govuk::apps::search_api(
  $rabbitmq_user,
  $port,
  $enable_procfile_worker = true,
  $enable_govuk_index_listener = false,
  $enable_bulk_reindex_listener = false,
  $enable_publishing_listener = false,
  $sentry_dsn = undef,
  $publishing_api_bearer_token = undef,
  $email_alert_api_bearer_token = undef,
  $google_client_email = undef,
  $google_private_key = undef,
  $google_analytics_govuk_view_id = undef,
  $google_bigquery_credentials = undef,
  $google_export_account_id = undef,
  $google_export_web_property_id = undef,
  $google_export_custom_data_source_id = undef,
  $rabbitmq_hosts = ['localhost'],
  $rabbitmq_url = '',
  $rabbitmq_password = 'search-api',
  $redis_host = undef,
  $redis_port = undef,
  $spelling_dependencies = 'present',
  $elasticsearch_hosts = undef,
  $unicorn_worker_processes = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $relevancy_bucket_name = undef,
  $sitemaps_bucket_name = undef,
  $aws_region = 'eu-west-1',
  $enable_learning_to_rank = false,
  $tensorflow_sagemaker_endpoint = undef,
  $tensorflow_sagemaker_variants = undef,
  $unicorn_timeout = 15,
) {
  $app_name = 'search-api'

  package { ['aspell', 'aspell-en', 'libaspell-dev']:
    ensure => $spelling_dependencies,
  }

  govuk::app { 'search-api':
    app_type                       => 'rack',
    port                           => $port,
    sentry_dsn                     => $sentry_dsn,
    health_check_custom_doc        => true,
    has_liveness_health_check      => true,
    has_readiness_health_check     => true,

    vhost_aliases                  => ['search'],

    log_format_is_json             => true,
    nginx_extra_config             => '
    client_max_body_size 500m;
    ',
    unicorn_worker_processes       => $unicorn_worker_processes,
    alert_when_file_handles_exceed => 4000,
  }

  govuk::app::envvar::rabbitmq { 'search-api':
    hosts    => $rabbitmq_hosts,
    user     => $rabbitmq_user,
    password => $rabbitmq_password,
    url      => $rabbitmq_url,
  }

  govuk::app::envvar::redis { 'search-api':
    host => $redis_host,
    port => $redis_port,
  }

  govuk::procfile::worker { 'search-api':
    enable_service => $enable_procfile_worker,
  }

  govuk::procfile::worker { 'search-api-publishing-queue-listener':
    setenv_as      => $app_name,
    enable_service => $enable_publishing_listener,
    process_type   => 'publishing-queue-listener',
    process_regex  => '\/rake message_queue:listen_to_publishing_queue',
  }

  govuk::procfile::worker { 'search-api-govuk-index-queue-listener':
    setenv_as      => $app_name,
    enable_service => $enable_govuk_index_listener,
    process_type   => 'govuk-index-queue-listener',
    process_regex  => '\/rake message_queue:insert_data_into_govuk',
  }

  govuk::procfile::worker { 'search-api-bulk-reindex-queue-listener':
    setenv_as      => $app_name,
    enable_service => $enable_bulk_reindex_listener,
    process_type   => 'bulk-reindex-queue-listener',
    process_regex  => '\/rake message_queue:bulk_insert_data_into_govuk',
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar {
    "${title}-UNICORN_TIMEOUT":
      varname => 'UNICORN_TIMEOUT',
      value   => $unicorn_timeout;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
      varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
      value   => $email_alert_api_bearer_token;
    "${title}-GOOGLE_ANALYTICS_GOVUK_VIEW_ID":
      varname => 'GOOGLE_ANALYTICS_GOVUK_VIEW_ID',
      value   => $google_analytics_govuk_view_id;
    "${title}-GOOGLE_BIGQUERY_CREDENTIALS":
      varname => 'GOOGLE_BIGQUERY_CREDENTIALS',
      value   => $google_bigquery_credentials;
    "${title}-GOOGLE_CLIENT_EMAIL":
      varname => 'GOOGLE_CLIENT_EMAIL',
      value   => $google_client_email;
    "${title}-GOOGLE_PRIVATE_KEY":
      varname => 'GOOGLE_PRIVATE_KEY',
      value   => $google_private_key;
    "${title}-GOOGLE_EXPORT_ACCOUNT_ID":
      varname => 'GOOGLE_EXPORT_ACCOUNT_ID',
      value   => $google_export_account_id;
    "${title}-GOOGLE_EXPORT_CUSTOM_DATA_SOURCE_ID":
      varname => 'GOOGLE_EXPORT_CUSTOM_DATA_SOURCE_ID',
      value   => $google_export_custom_data_source_id;
    "${title}-GOOGLE_EXPORT_WEB_PROPERTY_ID":
      varname => 'GOOGLE_EXPORT_WEB_PROPERTY_ID',
      value   => $google_export_web_property_id;
    "${title}-ELASTICSEARCH_URI":
      varname => 'ELASTICSEARCH_URI',
      value   => $elasticsearch_hosts;
    "${title}-ELASTICSEARCH_HOSTS":
      varname => 'ELASTICSEARCH_HOSTS',
      value   => $elasticsearch_hosts;
    "${title}-GDS_SSO_OAUTH_ID":
      varname => 'GDS_SSO_OAUTH_ID',
      value   => $oauth_id;
    "${title}-GDS_SSO_OAUTH_SECRET":
      varname => 'GDS_SSO_OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-AWS_REGION":
      varname => 'AWS_REGION',
      value   => $aws_region;
    "${title}-AWS_S3_RELEVANCY_BUCKET_NAME":
      varname => 'AWS_S3_RELEVANCY_BUCKET_NAME',
      value   => $relevancy_bucket_name;
    "${title}-AWS_S3_SITEMAPS_BUCKET_NAME":
      varname => 'AWS_S3_SITEMAPS_BUCKET_NAME',
      value   => $sitemaps_bucket_name;
    "${title}-ENABLE_LTR":
      varname => 'ENABLE_LTR',
      value   => bool2str($enable_learning_to_rank);
    "${title}-TENSORFLOW_SAGEMAKER_ENDPOINT":
      varname => 'TENSORFLOW_SAGEMAKER_ENDPOINT',
      value   => $tensorflow_sagemaker_endpoint;
    "${title}-TENSORFLOW_SAGEMAKER_VARIANTS":
      varname => 'TENSORFLOW_SAGEMAKER_VARIANTS',
      value   => $tensorflow_sagemaker_variants;
  }
}
