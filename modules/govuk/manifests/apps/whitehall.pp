# == Class: govuk::apps::whitehall
#
# Configure the whitehall application
#
# === Parameters
#
# FIXME: Document all class parameters
#
# [*admin_db_hostname*]
#   The hostname of the admin database server to use in the DATABASE_URL.
#
# [*admin_db_name*]
#   The database name to use in the admin DATABASE_URL.
#
# [*admin_db_password*]
#   The password for the admin database.
#
# [*admin_db_username*]
#   The username to use in the admin DATABASE_URL.
#
# [*admin_key_space_limit*]
#   Rack limit for how many form parameters it will parse.
#   Default: undef
#
# [*asset_host*]
#   The URL that will be used as a prefix for whitehall assets.
#   Default: undef
#
# [*asset_manager_bearer_token*]
#   The bearer token to use when communicating with Asset Manager.
#   Default: undef
#
# [*basic_auth_credentials*]
#   Basic auth credentials (necessary for LinkChecker config) used
#   by some environments.
#   Default: undef
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
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
#   Default: undef
#
# [*highlight_words_to_avoid*]
#   Boolean to turn on active highlighting of words to avoid.
#   Default: false
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
# [*oauth_id*]
#   Sets the OAuth ID for using GDS-SSO
#   Default: undef
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key for using GDS-SSO
#   Default: undef
#
# [*port*]
#   The port where the Rails app is running.
#
# [*prevent_single_host*]
#   This manifest will deliberately fail if the frontend and admin are on the
#   same machine and this flag is not set in hiera
#   Default: true
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
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
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#   Default: undef
#
# [*jwt_auth_secret*]
#   The secret used to encode JWT authentication tokens. This value needs to be
#   shared with authenticating-proxy which decodes the tokens.
#
# [*co_nss_watchkeeper_email_address*]
#   The email address of the CO NSS Watchkeeper user, which should only publish
#   in emergencies. All publishing by this user in production will generate an
#   email to the content second line group in GDS.
#   Default: undef
#
# [*link_checker_api_secret_token*]
#   The Link Checker API secret token.
#   Default: undef
#
# [*link_checker_api_bearer_token*]
#   The bearer token that will be used to authenticate with link-checker-api
#   Default: undef
#
# [*email_alert_api_bearer_token*]
#   Bearer token for communication with the email-alert-api
#
# [*cpu_warning*]
#   CPU usage percentage that alerts are sounded at
#   Default: undef
#
# [*cpu_critical*]
#   CPU usage percentage that alerts are sounded at
#
# [*rummager_bearer_token*]
#   The bearer token to use when communicating with Rummager.
#   Default: undef
#
# [*override_search_location*]
#   Alternative hostname to use for Plek("search") and Plek("rummager")
#
# [*frontend_unicorn_worker_processes*]
#   The number of unicorn work processes on the frontend when
#   `configure_frontend` is enabled.
#   Default: 8
#
# [*backend_unicorn_worker_processes*]
#   The number of unicorn work processes on the backend when
#   `configure_frontend` is disabled.
#   Default: 4
#
# [*govuk_notify_api_key*]
#   The API key used to send email via GOV.UK Notify.
#
# [*govuk_notify_template_id*]
#   The template ID used to send email via GOV.UK Notify.
#

class govuk::apps::whitehall(
  $admin_db_name = undef,
  $admin_db_hostname = undef,
  $admin_db_password = undef,
  $admin_db_username = undef,
  $admin_key_space_limit = undef,
  $asset_manager_bearer_token = undef,
  $asset_host = undef,
  $basic_auth_credentials = undef,
  $configure_frontend = false,
  $configure_admin = false,
  $db_name = undef,
  $db_hostname = undef,
  $db_password = undef,
  $db_username = undef,
  $email_alert_api_bearer_token = undef,
  $enable_procfile_worker = true,
  $sentry_dsn = undef,
  $highlight_words_to_avoid = false,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $port,
  $prevent_single_host = true,
  $procfile_worker_process_count = 1,
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
  $secret_key_base = undef,
  $vhost = 'whitehall',
  $vhost_protected,
  $jwt_auth_secret = undef,
  $co_nss_watchkeeper_email_address = undef,
  $link_checker_api_secret_token = undef,
  $link_checker_api_bearer_token = undef,
  $cpu_warning = 150,
  $cpu_critical = 200,
  $rummager_bearer_token = undef,
  $override_search_location = undef,
  $frontend_unicorn_worker_processes = 8,
  $backend_unicorn_worker_processes = 4,
  $govuk_notify_api_key = undef,
  $govuk_notify_template_id = undef,
) {

  $app_name = 'whitehall'
  $app_domain = hiera('app_domain')

  $health_check_path = '/healthcheck'

  # The number of worker processes differs for frontend vs. backend configs.
  if $configure_frontend {
    $unicorn_worker_processes = $frontend_unicorn_worker_processes
  } else {
    $unicorn_worker_processes = $backend_unicorn_worker_processes
  }

  validate_bool($prevent_single_host)
  if $prevent_single_host {
    if $configure_frontend == true and $configure_admin == true {
      fail('You should not be configuring whitehall-frontend and whitehall-admin on the same node')
    }
  }

  govuk::app { $app_name:
    app_type                 => 'rack',
    vhost                    => $vhost,
    port                     => $port,
    sentry_dsn               => $sentry_dsn,
    log_format_is_json       => true,
    health_check_path        => $health_check_path,
    expose_health_check      => false,
    json_health_check        => true,
    depends_on_nfs           => true,
    enable_nginx_vhost       => false,
    nagios_memory_warning    => $nagios_memory_warning,
    nagios_memory_critical   => $nagios_memory_critical,
    unicorn_herder_timeout   => 45,
    require                  => Package['unzip'],
    unicorn_worker_processes => $unicorn_worker_processes,
    cpu_warning              => $cpu_warning,
    cpu_critical             => $cpu_critical,
    override_search_location => $override_search_location,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  if $configure_frontend == true {
    if $::aws_migration {
      $whitehall_frontend_vhost_  = 'whitehall-frontend'
      $whitehall_frontend_aliases = ['draft-whitehall-frontend']
    } else {
      $whitehall_frontend_vhost_  = "whitehall-frontend.${app_domain}"
      $whitehall_frontend_aliases = ["draft-whitehall-frontend.${app_domain}"]
    }

    govuk::app::nginx_vhost { 'whitehall-frontend':
      vhost                   => $whitehall_frontend_vhost_,
      aliases                 => $whitehall_frontend_aliases,
      protected               => $vhost_protected,
      app_port                => $port,
      asset_pipeline          => true,
      asset_pipeline_prefixes => ['government/assets', 'assets/whitehall'],
    }

    # govuk::app::config doesn't automatically configure Whitehall's LB healthcheck
    # because Whitehall sets $enable_nginx_vhost=false. We therefore need to
    # configure the LB healthcheck explicitly.
    if $::aws_migration {
      concat::fragment { "${whitehall_frontend_vhost_}_lb_healthcheck":
        target  => '/etc/nginx/lb_healthchecks.conf',
        content => "location /_healthcheck_${whitehall_frontend_vhost_} {\n  proxy_pass http://${whitehall_frontend_vhost_}-proxy${health_check_path};\n}\n",
      }
    }

    govuk::app::envvar::database_url { $app_name:
      type     => 'mysql2',
      username => $db_username,
      password => $db_password,
      host     => $db_hostname,
      database => $db_name,
    }
  }

  if $configure_admin == true {
    include assets

    if $::aws_migration {
      $whitehall_admin_vhost_ = 'whitehall-admin'
    } else {
      $whitehall_admin_vhost_ = "whitehall-admin.${app_domain}"
    }

    govuk::app::nginx_vhost { 'whitehall-admin':
      vhost                   => $whitehall_admin_vhost_,
      app_port                => $port,
      protected               => $vhost_protected,
      protected_location      => '/government/admin/fact_check_requests/',
      deny_framing            => true,
      deny_crawlers           => true,
      asset_pipeline          => true,
      asset_pipeline_prefixes => ['government/assets', 'assets/whitehall'],
      hidden_paths            => [$health_check_path],
      nginx_extra_config      => '
      proxy_set_header X-Sendfile-Type X-Accel-Redirect;

      client_max_body_size 500m;

      # Don\'t ask for basic auth on API pages so internal apps can hit them
      # more easily.
      location /api {
        auth_basic off;
        try_files $uri @app;
      }
      location /government/admin/api {
        auth_basic off;
        try_files $uri @app;
      }

      # Don\'t ask for basic auth on SSO API pages so we can sync
      # permissions.
      location /auth/gds {
        auth_basic off;
        try_files $uri @app;
      }

      # Don\'t block access to the overdue healthcheck page.  Icinga needs to be
      # able to access this from the monitoring machine.
      # This is necessary because "/healthcheck*" is blocked by the hidden_paths option above.
      location /healthcheck/overdue {
        try_files $uri @app;
      }
    ',
    }

    # govuk::app::config doesn't automatically configure Whitehall's LB healthcheck
    # because Whitehall sets $enable_nginx_vhost=false. We therefore need to
    # configure the LB healthcheck explicitly.
    if $::aws_migration {
      concat::fragment { "${whitehall_admin_vhost_}_lb_healthcheck":
        target  => '/etc/nginx/lb_healthchecks.conf',
        content => "location /_healthcheck_${whitehall_admin_vhost_} {\n  proxy_pass http://${whitehall_admin_vhost_}-proxy${health_check_path};\n}\n",
      }
    }

    @filebeat::prospector { 'whitehall_scheduled_publishing_json_log':
      paths  => ['/var/apps/whitehall/log/production_scheduled_publishing.json.log'],
      fields => {'application' => 'whitehall'},
      json   => {'add_error_key' => true},
    }

    govuk::procfile::worker { 'whitehall-admin':
      setenv_as                 => $app_name,
      enable_service            => $enable_procfile_worker,
      process_count             => $procfile_worker_process_count,
      memory_warning_threshold  => 4000,
      memory_critical_threshold => 14000,
    }

    govuk::app::envvar {
      "${title}-ASSET_MANAGER_BEARER_TOKEN":
        varname => 'ASSET_MANAGER_BEARER_TOKEN',
        value   => $asset_manager_bearer_token;
      "${title}-HIGHLIGHT_WORDS_TO_AVOID":
        varname => 'HIGHLIGHT_WORDS_TO_AVOID',
        value   => bool2str($highlight_words_to_avoid);
      "${title}-KEY_SPACE_LIMIT":
        varname => 'KEY_SPACE_LIMIT',
        value   => $admin_key_space_limit;
      "${title}-OAUTH_ID":
        varname => 'OAUTH_ID',
        value   => $oauth_id;
      "${title}-OAUTH_SECRET":
        varname => 'OAUTH_SECRET',
        value   => $oauth_secret;
      "${title}-LINK_CHECKER_API_SECRET_TOKEN":
        varname => 'LINK_CHECKER_API_SECRET_TOKEN',
        value   => $link_checker_api_secret_token;
      "${title}-LINK_CHECKER_API_BEARER_TOKEN":
          varname => 'LINK_CHECKER_API_BEARER_TOKEN',
          value   => $link_checker_api_bearer_token;
      "${title}-GOVUK_NOTIFY_API_KEY":
        varname => 'GOVUK_NOTIFY_API_KEY',
        value   => $govuk_notify_api_key;
      "${title}-GOVUK_NOTIFY_TEMPLATE_ID":
        varname => 'GOVUK_NOTIFY_TEMPLATE_ID',
        value   => $govuk_notify_template_id;
    }

    govuk::app::envvar::database_url { $app_name:
      type     => 'mysql2',
      username => $admin_db_username,
      password => $admin_db_password,
      host     => $admin_db_hostname,
      database => $admin_db_name,
    }
  }

  govuk::app::envvar::redis { 'whitehall':
    host => $redis_host,
    port => $redis_port,
  }

  govuk::app::envvar {
    "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
      varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
      value   => $email_alert_api_bearer_token;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-RUMMAGER_BEARER_TOKEN":
      varname => 'RUMMAGER_BEARER_TOKEN',
      value   => $rummager_bearer_token;
  }

  if $asset_host != undef {
    govuk::app::envvar {
      "${title}-ASSET_HOST":
        varname => 'ASSET_HOST',
        value   => $asset_host;
    }
  }

  if $basic_auth_credentials != undef {
    govuk::app::envvar {
      "${title}-BASIC_AUTH_CREDENTIALS":
        varname => 'BASIC_AUTH_CREDENTIALS',
        value   => $basic_auth_credentials;
    }
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }

  if $jwt_auth_secret != undef {
    govuk::app::envvar { "${title}-JWT_AUTH_SECRET":
      varname => 'JWT_AUTH_SECRET',
      value   => $jwt_auth_secret,
    }
  }

  if $co_nss_watchkeeper_email_address != undef {
    govuk::app::envvar { "${title}-CO_NSS_WATCHKEEPER_EMAIL_ADDRESS":
      varname => 'CO_NSS_WATCHKEEPER_EMAIL_ADDRESS',
      value   => $co_nss_watchkeeper_email_address,
    }
  }

  include icinga::plugin::publish_overdue_whitehall
}
