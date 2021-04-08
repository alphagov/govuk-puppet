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
# [*govuk_notify_recipients*]
#   Indicates email addresses that will receive emails from Notify. This can
#   can be a string of "*" to indicate everyone or it can be an email address
#   or an array of email addressses.
#
# [*govuk_notify_template_id*]
#   Template ID for GOV.UK Notify
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*oauth_id*]
#   The OAuth ID used by GDS-SSO to identify the app to GOV.UK Signon
#
# [*oauth_secret*]
#   The OAuth secret used by GDS-SSO to authenticate the app to GOV.UK Signon
#
# [*email_alert_auth_token*]
#   Sets the secret token used for encrypting and decrypting messages shared
#   between email alert applications
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
# [*db_port*]
#   The port of the database server to use in the DATABASE_URL.
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
  $port,
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
  $govuk_notify_recipients = undef,
  $govuk_notify_template_id = undef,
  $secret_key_base = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $email_alert_auth_token = undef,
  $db_username = 'email-alert-api',
  $db_password = undef,
  $db_hostname = undef,
  $db_port = undef,
  $db_name = 'email-alert-api_production',
  $unicorn_worker_processes = undef,
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $aws_region = 'eu-west-1',
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
    ensure                    => $ensure,
    enable_service            => $enable_procfile_worker,
    alert_when_threads_exceed => 100,
    memory_warning_threshold  => 8000,
    memory_critical_threshold => 10000,
  }

  Govuk::App::Envvar {
    ensure          => $ensure,
    app             => 'email-alert-api',
    notify_service  => $enabled,
  }

  govuk::app::envvar::database_url { 'email-alert-api':
    type     => 'postgresql',
    username => $db_username,
    password => $db_password,
    host     => $db_hostname,
    port     => $db_port,
    database => $db_name,
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
    "${title}-GDS_SSO_OAUTH_ID":
        varname => 'GDS_SSO_OAUTH_ID',
        value   => $oauth_id;
    "${title}-GDS_SSO_OAUTH_SECRET":
        varname => 'GDS_SSO_OAUTH_SECRET',
        value   => $oauth_secret;
    "${title}-EMAIL_ALERT_AUTH_TOKEN":
        varname => 'EMAIL_ALERT_AUTH_TOKEN',
        value   => $email_alert_auth_token;
    "${title}-AWS_ACCESS_KEY_ID":
        varname => 'AWS_ACCESS_KEY_ID',
        value   => $aws_access_key_id;
    "${title}-AWS_SECRET_ACCESS_KEY":
        varname => 'AWS_SECRET_ACCESS_KEY',
        value   => $aws_secret_access_key;
    "${title}-AWS_REGION":
        varname => 'AWS_REGION',
        value   => $aws_region;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
  }

  if $govuk_notify_recipients {
    $recipients = is_array($govuk_notify_recipients) ? {
      true  => join($govuk_notify_recipients, ','),
      false => $govuk_notify_recipients
    }

    govuk::app::envvar { "${title}-GOVUK_NOTIFY_RECIPIENTS":
      varname => 'GOVUK_NOTIFY_RECIPIENTS',
      value   => $recipients;
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
