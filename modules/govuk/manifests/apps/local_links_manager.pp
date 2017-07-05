# Class: govuk::apps::local_links_manager
#
# App to manage the local links within GOV.UK so that
# they can be used for local transactions.
# https://github.com/alphagov/local-links-manager
#
# [*port*]
#   What port should the app run on?
#
# [*enabled*]
#   Should the app exist?
#   Default: true
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: undef
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
class govuk::apps::local_links_manager(
  $port = 3121,
  $enabled = true,
  $errbit_api_key = undef,
  $secret_key_base = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $db_hostname = undef,
  $db_username = 'local_links_manager',
  $db_password = undef,
  $db_name = 'local-links-manager_production',
  $redis_host = undef,
  $redis_port = undef,
  $local_links_manager_passive_checks = false,
  $google_analytics_govuk_view_id = undef,
  $google_client_email = undef,
  $google_private_key = undef,
  $publishing_api_bearer_token = undef,
  $link_checker_api_secret_token = undef,
) {
  $app_name = 'local-links-manager'

  if $enabled {
    govuk::app { $app_name:
      app_type          => 'rack',
      port              => $port,
      vhost_ssl_only    => true,
      health_check_path => '/healthcheck',
    }

    Govuk::App::Envvar {
      app    => $app_name,
    }

    govuk::app::envvar::redis { $app_name:
      host => $redis_host,
      port => $redis_port,
    }

    govuk::app::envvar {
      "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
      "${title}-GOOGLE_ANALYTICS_GOVUK_VIEW_ID":
        varname => 'GOOGLE_ANALYTICS_GOVUK_VIEW_ID',
        value   => $google_analytics_govuk_view_id;
      "${title}-GOOGLE_CLIENT_EMAIL":
        varname => 'GOOGLE_CLIENT_EMAIL',
        value   => $google_client_email;
      "${title}-GOOGLE_PRIVATE_KEY":
        varname => 'GOOGLE_PRIVATE_KEY',
        value   => $google_private_key;
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
    }

    if $local_links_manager_passive_checks {
      @@icinga::passive_check { "link-checker-${::hostname}":
        service_description => 'Local Links Manager link checker rake task',
        host_name           => $::fqdn,
        freshness_threshold => 26 * (60 * 60),
      }

      @@icinga::passive_check { "local-links-manager-import-service-interactions_${::hostname}":
        service_description => 'Import services and interactions into local-links-manager',
        host_name           => $::fqdn,
        freshness_threshold => (32 * 24 * 60 * 60), #the job runs monthly on the 1st
      }

      @@icinga::passive_check { "local-links-manager-export-links_${::hostname}":
        service_description => 'Export links to CSV from local-links-manager',
        host_name           => $::fqdn,
        freshness_threshold => (25 * 60 * 60), # 25 hrs (e.g. just over a day)
      }
    }

    if $::govuk_node_class !~ /^(development|training)$/ {
      govuk::app::envvar::database_url { $app_name:
        type     => 'postgresql',
        username => $db_username,
        password => $db_password,
        host     => $db_hostname,
        database => $db_name,
      }
    }

  }
}
