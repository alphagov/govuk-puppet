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
# [*allow_govdelivery_topic_syncing*]
#   If set to `true`, allows the running of a script which deletes all topics
#   in GovDelivery and replaces them with copies from the email alert API database.
#   Must only be configured to `true` in staging or integration, never production.
#   Default: false
#
# [* disable_govdelivery_emails*]
#   If set this disables the sending of email bulletins to govdelivery and will
#   mean users aren't notified of events unless a different system (notably
#   the notify based one) is in operation.
#   Default: false
#
# [*use_email_alert_frontend_for_email_collection*]
#   If set, users will be redirected to email-alert-frontend to enter their
#   email address instead of govdelivery. This affects the `subscription_url`
#   in responses from the Email Alert API which is used by `collections`,
#   `finder-frontend` and `whitehall`.
#   Default: false
#
# [*govdelivery_username*]
#   Username used to authenticate with govdelivery API
#
# [*govdelivery_password*]
#   Password used to authenticate with govdelivery API
#
# [*govdelivery_account_code*]
#   Identifier for GOV.UK within the govdelivery service
#
# [*govdelivery_protocol*]
#   Protocol used for the govdelivery service
#
# [*govdelivery_hostname*]
#   Hostname for the govdelivery API (changes depending on environment)
#
# [*govdelivery_public_hostname*]
#   Public hostname for the govdelivery API
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
# [*govuk_notify_rate_per_worker*]
#   Number of requests per seconds that the notify delivery worker
#   is allowed to make (currently 50 requests/s / 6 workers = 8 (ish)
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
class govuk::apps::email_alert_api(
  $port = '3088',
  $enabled = false,
  $enable_public_proxy = true,
  $enable_procfile_worker = true,
  $sidekiq_retry_critical = '20',
  $sidekiq_retry_warning = '10',
  $sidekiq_queue_size_critical = '100000',
  $sidekiq_queue_size_warning = '75000',
  $sidekiq_queue_latency_critical = '300',
  $sidekiq_queue_latency_warning = '250',
  $redis_host = undef,
  $redis_port = undef,
  $sentry_dsn = undef,
  $allow_govdelivery_topic_syncing = false,
  $disable_govdelivery_emails = false,
  $use_email_alert_frontend_for_email_collection = false,
  $govdelivery_username = undef,
  $govdelivery_password = undef,
  $govdelivery_account_code = undef,
  $govdelivery_protocol = 'https',
  $govdelivery_hostname = undef,
  $govdelivery_public_hostname = undef,
  $govuk_notify_api_key = undef,
  $govuk_notify_base_url = undef,
  $govuk_notify_template_id = undef,
  $govuk_notify_rate_per_worker = undef,
  $secret_key_base = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $email_service_provider = 'NOTIFY',
  $email_address_override = undef,
  $email_address_override_whitelist = undef,
  $email_address_override_whitelist_only = false,
  $delivery_request_threshold = undef,
  $db_username = 'email-alert-api',
  $db_password = undef,
  $db_hostname = undef,
  $db_name = 'email-alert-api_production',
  $unicorn_worker_processes = undef,
) {

  if $enabled {
    govuk::app { 'email-alert-api':
      app_type                 => 'rack',
      port                     => $port,
      sentry_dsn               => $sentry_dsn,
      log_format_is_json       => true,
      health_check_path        => '/healthcheck',
      json_health_check        => true,
      unicorn_worker_processes => $unicorn_worker_processes,
    }

    include govuk_postgresql::client #installs libpq-dev package needed for pg gem

    govuk::procfile::worker {'email-alert-api':
      enable_service => $enable_procfile_worker,
    }

    @filebeat::prospector { 'govdelivery_json_log':
      paths  => ['/var/apps/email-alert-api/log/govdelivery.log'],
      fields => {'application' => 'email-alert-api-govdelivery'},
      json   => {'add_error_key' => true},
    }

    Govuk::App::Envvar {
      app => 'email-alert-api',
    }

    if $::govuk_node_class !~ /^development$/ {
      govuk::app::envvar::database_url { 'email-alert-api':
        type     => 'postgresql',
        username => $db_username,
        password => $db_password,
        host     => $db_hostname,
        database => $db_name,
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
      "${title}-GOVDELIVERY_USERNAME":
          varname => 'GOVDELIVERY_USERNAME',
          value   => $govdelivery_username;
      "${title}-GOVDELIVERY_PASSWORD":
          varname => 'GOVDELIVERY_PASSWORD',
          value   => $govdelivery_password;
      "${title}-GOVDELIVERY_ACCOUNT_CODE":
          varname => 'GOVDELIVERY_ACCOUNT_CODE',
          value   => $govdelivery_account_code;
      "${title}-GOVDELIVERY_PROTOCOL":
          varname => 'GOVDELIVERY_PROTOCOL',
          value   => $govdelivery_protocol;
      "${title}-GOVDELIVERY_HOSTNAME":
          varname => 'GOVDELIVERY_HOSTNAME',
          value   => $govdelivery_hostname;
      "${title}-GOVDELIVERY_PUBLIC_HOSTNAME":
          varname => 'GOVDELIVERY_PUBLIC_HOSTNAME',
          value   => $govdelivery_public_hostname;
      "${title}-GOVUK_NOTIFY_API_KEY":
          varname => 'GOVUK_NOTIFY_API_KEY',
          value   => $govuk_notify_api_key;
      "${title}-GOVUK_NOTIFY_TEMPLATE_ID":
          varname => 'GOVUK_NOTIFY_TEMPLATE_ID',
          value   => $govuk_notify_template_id;
      "${title}-GOVUK_NOTIFY_BASE_URL":
          ensure  => 'absent',
          varname => 'GOVUK_NOTIFY_BASE_URL',
          value   => $govuk_notify_base_url;
      "${title}-GOVUK_NOTIFY_RATE_PER_WORKER":
          varname => 'GOVUK_NOTIFY_RATE_PER_WORKER',
          value   => $govuk_notify_rate_per_worker;
      "${title}-SECRET_KEY_BASE":
          varname => 'SECRET_KEY_BASE',
          value   => $secret_key_base;
      "${title}-OAUTH_ID":
          varname => 'OAUTH_ID',
          value   => $oauth_id;
      "${title}-OAUTH_SECRET":
          varname => 'OAUTH_SECRET',
          value   => $oauth_secret;
      "${title}-EMAIL_SERVICE_PROVIDER":
          varname => 'EMAIL_SERVICE_PROVIDER',
          value   => $email_service_provider;
      "${title}-EMAIL_ADDRESS_OVERRIDE":
          varname => 'EMAIL_ADDRESS_OVERRIDE',
          value   => $email_address_override;
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

    if $allow_govdelivery_topic_syncing {
      govuk::app::envvar { "${title}-ALLOW_GOVDELIVERY_SYNC":
        varname => 'ALLOW_GOVDELIVERY_SYNC',
        value   => 'allow';
      }
    }

    if $disable_govdelivery_emails {
      govuk::app::envvar { "${title}-DISABLE_GOVDELIVERY_EMAILS":
        varname => 'DISABLE_GOVDELIVERY_EMAILS',
        value   => 'yes';
      }
    }

    if $use_email_alert_frontend_for_email_collection {
      govuk::app::envvar { "${title}-USE_EMAIL_ALERT_FRONTEND_FOR_EMAIL_COLLECTION":
        varname => 'USE_EMAIL_ALERT_FRONTEND_FOR_EMAIL_COLLECTION',
        value   => 'yes';
      }
    }

    $app_domain = hiera('app_domain')

    if $enable_public_proxy {
      nginx::conf { 'email-alert-api-public-rate-limiting':
        content => '
          limit_req_zone $binary_remote_addr zone=email_alert_api_public:1m rate=100r/s;
          limit_req_status 429;
        ',
      }

      if $::aws_migration {
        $vhost_ = 'email-alert-api-public'
      } else {
        $vhost_ = "email-alert-api-public.${app_domain}"
      }

      nginx::config::vhost::proxy { $vhost_:
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
}
