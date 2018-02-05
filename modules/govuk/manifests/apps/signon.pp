# == Class: govuk::apps::signon
#
# The GOV.UK Signon application -- single sign-on service for GOV.UK
#
# === Parameters
#
# [*db_hostname*]
#   The hostname of the database server to use in the DATABASE_URL.
#
# [*db_name*]
#   The database name to use in the DATABASE_URL.
#
# [*db_password*]
#   The password for the database.
#
# [*db_username*]
#   The username to use in the DATABASE_URL.
#
# [*devise_pepper*]
#   The pepper used by Devise to encrypt passwords more strongly.
#
# [*devise_secret_key*]
#   The secret key used by Devise to generate random tokens.
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker. Typically used to disable the worker
#   on the dev VM.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*instance_name*]
#   Environment specific name used when sending emails.
#   Default: undef
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*port*]
#   The port that it is served on.
#   Default: 3016
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*sso_push_user_email*]
#   Email address for the SSO sync push user.
#
# [*unicorn_worker_processes*]
#   The number of unicorn worker processes to run
#   Default: undef
#
class govuk::apps::signon(
  $db_hostname = undef,
  $db_name = undef,
  $db_password = undef,
  $db_username = undef,
  $devise_pepper = undef,
  $devise_secret_key = undef,
  $enable_procfile_worker = true,
  $sentry_dsn = undef,
  $instance_name = undef,
  $nagios_memory_critical = undef,
  $nagios_memory_warning = undef,
  $port = '3016',
  $redis_host = undef,
  $redis_port = undef,
  $secret_key_base = undef,
  $sso_push_user_email = undef,
  $unicorn_worker_processes = undef,
) {
  $app_name = 'signon'

  govuk::app { $app_name:
    app_type                 => 'rack',
    port                     => $port,
    sentry_dsn               => $sentry_dsn,
    vhost_ssl_only           => true,
    health_check_path        => '/users/sign_in',
    asset_pipeline           => true,
    deny_framing             => true,
    nagios_memory_warning    => $nagios_memory_warning,
    nagios_memory_critical   => $nagios_memory_critical,
    unicorn_worker_processes => $unicorn_worker_processes,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::procfile::worker { $app_name:
    enable_service => $enable_procfile_worker,
  }

  govuk::app::envvar {
    "${title}-DEVISE_PEPPER":
      varname => 'DEVISE_PEPPER',
      value   => $devise_pepper;
    "${title}-DEVISE_SECRET_KEY":
      varname => 'DEVISE_SECRET_KEY',
      value   => $devise_secret_key;
    "${title}-SSO_PUSH_USER_EMAIL":
      varname => 'SSO_PUSH_USER_EMAIL',
      value   => $sso_push_user_email;
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  if $instance_name != undef {
    govuk::app::envvar { "${title}-INSTANCE_NAME":
      varname => 'INSTANCE_NAME',
      value   => $instance_name,
    }
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }

  if $::govuk_node_class !~ /^development$/ {
    govuk::app::envvar::database_url { $app_name:
      type     => 'mysql2',
      username => $db_username,
      password => $db_password,
      host     => $db_hostname,
      database => $db_name,
    }
  }

  include govuk_postgresql::client #installs libpq-dev package needed for pg gem
}
