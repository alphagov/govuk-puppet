# == Class: govuk::apps::email_alert_api
#
# Email Alert API is an internal API for subscribing to and triggering email
# alerts.
#
# === Parameters
#
# [*port*]
#   What port should the app run on?
#
# [*enabled*]
#   Should the application should be enabled. Set in hiera data for each
#   environment.
#
# [*enable_public_proxy*]
#   Whether to create a public proxy into this application for handling
#   select public endpoints
#   Default: true
#
# [*enable_procfile_worker*]
#   Should the Foreman-based background worker be enabled by default. Set in
#   hiera.
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*govuk_notify_api_key*]
#   API key for integration with GOV.UK Notify for sending emails
#
# [*govuk_notify_template_id*]
#   Template ID for GOV.UK Notify
#
# [*govuk_notify_base_url*]
#   Deprecated env var to switch notify environments.
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*oauth_id*]
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
# [*email_alert_auth_token*]
#   Sets the secret token used for encrypting and decrypting messages shared
#   between email alert applications
#
# [*email_service_provider*]
#   Configure which provider to use for sending emails.
#    PSUEDO - Don't actually send emails, instead just log them.
#    NOTIFY - Use GOV.UK Notify to send the emails.
#
# [*email_address_override*]
#   Configure all emails to be sent to this address instead.
#
# [*email_address_override_whitelist*]
#   Allow a whitelist of email addresses that ignore the override option.
#
# [*email_address_override_whitelist_only*]
#   Specify that only emails that are whitelisted should be sent out.
#
# [*delivery_request_threshold*]
#   Configure the number of requests that the rate limit will allow to be made in one minute.
#
# [*unicorn_worker_processes*]
#   The number of unicorn workers to run for an instance of this app
#
# [*aws_access_key_id*]
#   An access key that can be use with Amazon Web Services
#
# [*aws_secret_access_key*]
#   The secret key that corresponds with the aws_access_key_id
#
# [*aws_region*]
#   The AWS region which is used for AWS Services
#   default: eu-west-1
#
# [*email_archive_s3_bucket*]
#   An S3 bucket in the specified AWS region which can be used to write the
#   archived data too
#
# [*email_archive_s3_enabled*]
#   Whether or not to perform S3 archiving in the current environment
#
# [*db_port*]
#   The port of the database server to use in the DATABASE_URL.
#   Default: undef
#
# [*db_allow_prepared_statements*]
#   The ?prepared_statements= parameter to use in the DATABASE_URL.
#   Default: undef
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
class govuk::apps::email_alert_api(
  $port = '3088',
  $enabled = false,
  $enable_public_proxy = true,
  $enable_procfile_worker = true,
  $sidekiq_retry_critical = '200',
  $sidekiq_retry_warning = '100',
  $sidekiq_queue_size_critical = '100000',
  $sidekiq_queue_size_warning = '75000',
  $sidekiq_queue_latency_critical = '300',
  $sidekiq_queue_latency_warning = '250',
  $redis_host = undef,
  $redis_port = undef,
  $sentry_dsn = undef,
  $govuk_notify_api_key = undef,
  $govuk_notify_base_url = undef,
  $govuk_notify_template_id = undef,
  $secret_key_base = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $email_alert_auth_token = undef,
  $email_service_provider = 'NOTIFY',
  $email_address_override = undef,
  $email_address_override_whitelist = undef,
  $email_address_override_whitelist_only = false,
  $delivery_request_threshold = undef,
  $db_username = 'email-alert-api',
  $db_password = undef,
  $db_hostname = undef,
  $db_port = undef,
  $db_allow_prepared_statements = undef,
  $db_name = 'email-alert-api_production',
  $unicorn_worker_processes = undef,
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $aws_region = 'eu-west-1',
  $email_archive_s3_bucket = undef,
  $email_archive_s3_enabled = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $publishing_api_bearer_token = undef,
) {

  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  govuk::app { 'email-alert-api':
    ensure                   => $ensure,
    app_type                 => 'rack',
    port                     => $port,
    sentry_dsn               => $sentry_dsn,
    log_format_is_json       => true,
    health_check_path        => '/healthcheck',
    json_health_check        => true,
    unicorn_worker_processes => $unicorn_worker_processes,
    nagios_memory_warning    => $nagios_memory_warning,
    nagios_memory_critical   => $nagios_memory_critical,
  }

  include govuk_postgresql::client #installs libpq-dev package needed for pg gem

  govuk::procfile::worker {'email-alert-api':
    ensure         => $ensure,
    enable_service => $enable_procfile_worker,
  }

  Govuk::App::Envvar {
    ensure          => $ensure,
    app             => 'email-alert-api',
    notify_service  => $enabled,
  }

  if $::govuk_node_class !~ /^development$/ {
    govuk::app::envvar::database_url { 'email-alert-api':
      type                      => 'postgresql',
      username                  => $db_username,
      password                  => $db_password,
      host                      => $db_hostname,
      port                      => $db_port,
      allow_prepared_statements => $db_allow_prepared_statements,
      database                  => $db_name,
    }
  }

  govuk::app::envvar::redis { 'email-alert-api':
    host => $redis_host,
    port => $redis_port,
  }

  govuk::app::envvar {
    "${title}-SIDEKIQ_RETRY_CRITICAL_THRESHOLD":
        varname => 'SIDEKIQ_RETRY_SIZE_CRITICAL',
        value   => $sidekiq_retry_critical;
    "${title}-SIDEKIQ_RETRY_WARNING_THRESHOLD":
        varname => 'SIDEKIQ_RETRY_SIZE_WARNING',
        value   => $sidekiq_retry_warning;
    "${title}-SIDEKIQ_QUEUE_SIZE_CRITICAL_THRESHOLD":
        varname => 'SIDEKIQ_QUEUE_SIZE_CRITICAL',
        value   => $sidekiq_queue_size_critical;
    "${title}-SIDEKIQ_QUEUE_SIZE_WARNING_THRESHOLD":
        varname => 'SIDEKIQ_QUEUE_SIZE_WARNING',
        value   => $sidekiq_queue_size_warning;
    "${title}-SIDEKIQ_QUEUE_LATENCY_CRITICAL_THRESHOLD":
        varname => 'SIDEKIQ_QUEUE_LATENCY_CRITICAL',
        value   => $sidekiq_queue_latency_critical;
    "${title}-SIDEKIQ_QUEUE_LATENCY_WARNING_THRESHOLD":
        varname => 'SIDEKIQ_QUEUE_LATENCY_WARNING',
        value   => $sidekiq_queue_latency_warning;
    "${title}-GOVUK_NOTIFY_API_KEY":
        varname => 'GOVUK_NOTIFY_API_KEY',
        value   => $govuk_notify_api_key;
    "${title}-GOVUK_NOTIFY_TEMPLATE_ID":
        varname => 'GOVUK_NOTIFY_TEMPLATE_ID',
        value   => $govuk_notify_template_id;
    "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
    "${title}-OAUTH_ID":
        varname => 'OAUTH_ID',
        value   => $oauth_id;
    "${title}-OAUTH_SECRET":
        varname => 'OAUTH_SECRET',
        value   => $oauth_secret;
    "${title}-EMAIL_ALERT_AUTH_TOKEN":
        varname => 'EMAIL_ALERT_AUTH_TOKEN',
        value   => $email_alert_auth_token;
    "${title}-EMAIL_SERVICE_PROVIDER":
        varname => 'EMAIL_SERVICE_PROVIDER',
        value   => $email_service_provider;
    "${title}-EMAIL_ADDRESS_OVERRIDE":
        varname => 'EMAIL_ADDRESS_OVERRIDE',
        value   => $email_address_override;
    "${title}-AWS_ACCESS_KEY_ID":
        varname => 'AWS_ACCESS_KEY_ID',
        value   => $aws_access_key_id;
    "${title}-AWS_SECRET_ACCESS_KEY":
        varname => 'AWS_SECRET_ACCESS_KEY',
        value   => $aws_secret_access_key;
    "${title}-AWS_REGION":
        varname => 'AWS_REGION',
        value   => $aws_region;
    "${title}-EMAIL_ARCHIVE_S3_BUCKET":
        varname => 'EMAIL_ARCHIVE_S3_BUCKET',
        value   => $email_archive_s3_bucket;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
  }

  if $email_address_override_whitelist {
    govuk::app::envvar { "${title}-EMAIL_ADDRESS_OVERRIDE_WHITELIST":
      varname => 'EMAIL_ADDRESS_OVERRIDE_WHITELIST',
      value   => join($email_address_override_whitelist, ',');
    }
  }

  if $email_address_override_whitelist_only {
    govuk::app::envvar { "${title}-EMAIL_ADDRESS_OVERRIDE_WHITELIST_ONLY":
      varname => 'EMAIL_ADDRESS_OVERRIDE_WHITELIST_ONLY',
      value   => 'yes';
    }
  }

  if $delivery_request_threshold {
    govuk::app::envvar { "${title}-DELIVERY_REQUEST_THRESHOLD":
      varname => 'DELIVERY_REQUEST_THRESHOLD',
      value   => $delivery_request_threshold;
    }
  }

  if $email_archive_s3_enabled {
    govuk::app::envvar { "${title}-EMAIL_ARCHIVE_S3_ENABLED":
      varname => 'EMAIL_ARCHIVE_S3_ENABLED',
      value   => 'yes';
    }
  }

  $app_domain = hiera('app_domain')

  if $enable_public_proxy {
    nginx::conf { 'email-alert-api-public-rate-limiting':
      ensure  => $ensure,
      content => '
        limit_req_zone $binary_remote_addr zone=email_alert_api_public:1m rate=50r/s;
        limit_req_status 429;
      ',
    }

    if $::aws_migration {
      $vhost_ = 'email-alert-api-public'
    } else {
      $vhost_ = "email-alert-api-public.${app_domain}"
    }

    nginx::config::vhost::proxy { $vhost_:
      ensure           => $ensure,
      to               => ["localhost:${port}"],
      ssl_only         => true,
      protected        => false,
      extra_app_config => "
        return 404;
      ",
      extra_config     => template('govuk/email_alert_api_public_nginx_extra_config.conf.erb'),
    }
  }
}
