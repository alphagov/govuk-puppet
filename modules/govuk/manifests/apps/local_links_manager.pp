# Class: govuk::apps::local_links_manager
#
# App to manage the local links within GOV.UK so that
# they can be used for local transactions.
# https://github.com/alphagov/local-links-manager
#
# [*ensure*]
#   Whether Local Links Manager should be present or absent.
#
# [*port*]
#   What port should the app run on?
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*secret_key_base*]
#   Used to set the app ENV var SECRET_KEY_BASE which is used to configure
#   rails 4.x signed cookie mechanism. If unset the app will be unable to
#   start.
#   Default: undef
#
# [*db_hostname*]
#   The hostname of the database server to use in the DATABASE_URL.
#   Default: undef
#
# [*db_username*]
#   The username to use in the DATABASE_URL.
#
# [*db_password*]
#   The password for the database.
#   Default: undef
#
# [*db_port*]
#   The port of the database server to use in the DATABASE_URL.
#   Default: undef
#
# [*db_allow_prepared_statements*]
#   The ?prepared_statements= parameter to use in the DATABASE_URL.
#   Default: undef
#
# [*db_name*]
#   The database name to use in the DATABASE_URL.
#
# [*oauth_id*]
#   Sets the OAuth ID for using GDS-SSO
#   Default: undef
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key for using GDS-SSO
#   Default: undef
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
# [*local_links_manager_passive_checks*]
#   Enables the passive checks in Icinga for the local links manager cron jobs
#   Default: false
#
# [*google_analytics_govuk_view_id*]
#   The view id of GOV.UK in Google Analytics
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
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*link_checker_api_secret_token*]
#   The secret token used when verifying web hook responses from the Link
#   Checker API.
#
# [*link_checker_api_bearer_token*]
#   The bearer token that will be used to authenticate with link-checker-api
#   Default: undef
#
# [*run_links_ga_export]
#   Feature flag to allow a daily rake task to upload a list of bad links
#   to GA.
#   Default: false
#
# [*unicorn_worker_processes*]
#   The number of unicorn worker processes to run
#   Default: undef
#
# [*app_domain]
#   The external subdomain used by the app
#   Default: undef
#
class govuk::apps::local_links_manager(
  $ensure = 'present',
  $port = 3121,
  $sentry_dsn = undef,
  $secret_key_base = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $db_hostname = undef,
  $db_username = 'local_links_manager',
  $db_password = undef,
  $db_port = undef,
  $db_allow_prepared_statements = undef,
  $db_name = 'local-links-manager_production',
  $redis_host = undef,
  $redis_port = undef,
  $local_links_manager_passive_checks = false,
  $google_analytics_govuk_view_id = undef,
  $publishing_api_bearer_token = undef,
  $link_checker_api_secret_token = undef,
  $link_checker_api_bearer_token = undef,
  $google_client_email = undef,
  $google_private_key = undef,
  $google_export_account_id = undef,
  $google_export_custom_data_import_source_id = undef,
  $google_export_tracker_id = undef,
  $run_links_ga_export = false,
  $unicorn_worker_processes = undef,
  $app_domain = undef,
) {
  $app_name = 'local-links-manager'

  govuk::app { $app_name:
    ensure                   => $ensure,
    app_type                 => 'rack',
    log_format_is_json       => true,
    port                     => $port,
    sentry_dsn               => $sentry_dsn,
    vhost_ssl_only           => true,
    health_check_path        => '/healthcheck',
    unicorn_worker_processes =>  $unicorn_worker_processes,
  }

  Govuk::App::Envvar {
    ensure => $ensure,
    app    => $app_name,
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  govuk::app::envvar {
    "${title}-GOOGLE_ANALYTICS_GOVUK_VIEW_ID":
      varname => 'GOOGLE_ANALYTICS_GOVUK_VIEW_ID',
      value   => $google_analytics_govuk_view_id;
    "${title}-GOOGLE_CLIENT_EMAIL":
      varname => 'GOOGLE_CLIENT_EMAIL',
      value   => $google_client_email;
    "${title}-GOOGLE_PRIVATE_KEY":
      varname => 'GOOGLE_PRIVATE_KEY',
      value   => $google_private_key;
    "${title}-GOOGLE_EXPORT_ACCOUNT_ID":
      varname => 'GOOGLE_EXPORT_ACCOUNT_ID',
      value   => $google_export_account_id;
    "${title}-GOOGLE_EXPORT_CUSTOM_DATA_IMPORT_SOURCE_ID":
      varname => 'GOOGLE_EXPORT_CUSTOM_DATA_IMPORT_SOURCE_ID',
      value   => $google_export_custom_data_import_source_id;
    "${title}-GOOGLE_EXPORT_TRACKER_ID":
      varname => 'GOOGLE_EXPORT_TRACKER_ID',
      value   => $google_export_tracker_id;
    "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-LINK_CHECKER_API_SECRET_TOKEN":
      varname => 'LINK_CHECKER_API_SECRET_TOKEN',
      value   => $link_checker_api_secret_token;
    "${title}-LINK_CHECKER_API_BEARER_TOKEN":
      varname => 'LINK_CHECKER_API_BEARER_TOKEN',
      value   => $link_checker_api_bearer_token;
    "${title}-RUN_LINK_GA_EXPORT":
      varname => 'RUN_LINK_GA_EXPORT',
      value   => bool2str($run_links_ga_export);
  }

  if $app_domain {
    govuk::app::envvar {
      "${title}-GOVUK_APP_DOMAIN":
        varname => 'GOVUK_APP_DOMAIN',
        value   => $app_domain;
      "${title}-GOVUK_APP_DOMAIN_EXTERNAL":
        varname => 'GOVUK_APP_DOMAIN_EXTERNAL',
        value   => $app_domain;
    }
  }

  if $local_links_manager_passive_checks {
    @@icinga::passive_check { "link-checker-${::hostname}":
      ensure              => $ensure,
      service_description => 'Local Links Manager link checker rake task',
      host_name           => $::fqdn,
      freshness_threshold => 26 * (60 * 60),
    }

    @@icinga::passive_check { "local-links-manager-import-service-interactions_${::hostname}":
      ensure              => $ensure,
      service_description => 'Import services and interactions into local-links-manager',
      host_name           => $::fqdn,
      freshness_threshold => (32 * 24 * 60 * 60), #the job runs monthly on the 1st
    }

    @@icinga::passive_check { "local-links-manager-export-links_${::hostname}":
      ensure              => $ensure,
      service_description => 'Export links to CSV from local-links-manager',
      host_name           => $::fqdn,
      freshness_threshold => (25 * 60 * 60), # 25 hrs (e.g. just over a day)
    }
  }

  if $::govuk_node_class !~ /^development$/ {
    govuk::app::envvar::database_url { $app_name:
      type                      => 'postgresql',
      username                  => $db_username,
      password                  => $db_password,
      host                      => $db_hostname,
      port                      => $db_port,
      allow_prepared_statements => $db_allow_prepared_statements,
      database                  => $db_name,
    }
  }
}
