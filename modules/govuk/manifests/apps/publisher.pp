# == Class: govuk::apps::publisher
#
# Set up the publisher app
#
# === Parameters
#
## [*ensure*]
#   Allow govuk app to be removed.
#
# [*port*]
#   The port which the app runs on.
#
# [*enable_procfile_worker*]
#   Boolean, whether the procfile worker should be enabled
#   Default: true
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*asset_manager_bearer_token*]
#   The bearer token to use when communicating with Asset Manager.
#   Default: undef
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*mongodb_name*]
#   The Mongo database to be used.
#
# [*mongodb_username*]
#   The username to use when logging to the MongoDB database,
#   only needed if the app uses documentdb rather than mongodb
#
# [*mongodb_password*]
#   The password to use when logging to the MongoDB database
#   only needed if the app uses documentdb rather than mongodb
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
# [*jwt_auth_secret*]
#   The secret used to encode JWT authentication tokens. This value needs to be
#   shared with authenticating-proxy which decodes the tokens.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*oauth_id*]
#   The OAuth ID used by GDS-SSO to identify the app to GOV.UK Signon
#
# [*oauth_secret*]
#   The OAuth secret used by GDS-SSO to authenticate the app to GOV.UK Signon
#
# [*fact_check_username*]
#   The username to use for Basic Auth for fact check
#
# [*fact_check_password*]
#   The password to use for Basic Auth for fact check
#
# [*fact_check_reply_to_id*]
#   The UUID (configured in Notify) for the reply-to address to be used on
#   fact-check emails
#
# [*fact_check_reply_to_address*]
#   The reply-to address to be used on fact-check emails (should match the
#   one referred to by fact_check_reply_to_id)
#
# [*email_group_dev*]
#   The email address to use dev alerts
#
# [*email_group_business*]
#   The email address to use business alerts
#
# [*email_group_citizen*]
#   The email address to use citizen alerts
#
# [*email_group_force_publish_alerts*]
#   The email address to use for skip review alerts
#
# [*link_checker_api_secret_token*]
#   The Link Checker API secret token.
#   Default: undef
#
# [*link_checker_api_bearer_token*]
#   The bearer token that will be used to authenticate with link-checker-api
#   Default: undef
#
# [*govuk_notify_api_key*]
#   The API key used to send email via GOV.UK Notify.
#
# [*govuk_notify_template_id*]
#   The template ID used to send email via GOV.UK Notify.
#
class govuk::apps::publisher(
    $ensure = 'present',
    $port,
    $enable_procfile_worker = true,
    $publishing_api_bearer_token = undef,
    $asset_manager_bearer_token = undef,
    $secret_key_base = undef,
    $mongodb_name = undef,
    $mongodb_nodes = undef,
    $mongodb_username = '',
    $mongodb_password = '',
    $redis_host = undef,
    $redis_port = undef,
    $jwt_auth_secret = undef,
    $alert_hostname = 'alert.cluster',
    $sentry_dsn = undef,
    $oauth_id = undef,
    $oauth_secret = undef,
    $fact_check_subject_prefix = undef,
    $fact_check_username = undef,
    $fact_check_password = undef,
    $fact_check_reply_to_id = undef,
    $fact_check_reply_to_address = undef,
    $email_group_dev = undef,
    $email_group_business = undef,
    $email_group_citizen = undef,
    $email_group_force_publish_alerts = undef,
    $link_checker_api_secret_token = undef,
    $link_checker_api_bearer_token = undef,
    $govuk_notify_api_key = undef,
    $govuk_notify_template_id = undef,
  ) {

  $app_name = 'publisher'

  validate_re($ensure, '^(present|absent)$', 'Invalid ensure value')

  govuk::app { $app_name:
    ensure                     => $ensure,
    app_type                   => 'rack',
    port                       => $port,
    sentry_dsn                 => $sentry_dsn,
    vhost_ssl_only             => true,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
    log_format_is_json         => true,
    asset_pipeline             => true,
    deny_framing               => true,
    nginx_extra_config         => '
    proxy_set_header X-Sendfile-Type X-Accel-Redirect;
    proxy_set_header X-Accel-Mapping /var/apps/publisher/reports/=/raw/;

    # /raw/(.*) is the path mapping sent from the rails application to
    # nginx and is immediately picked up. /raw/(.*) is not available
    # publicly as it is an internal path mapping.
    location ~ /raw/(.*) {
      internal;
      alias /var/apps/publisher/reports/$1;
    }',
  }

  file { '/usr/local/bin/local_authority_import_check':
    ensure  => $ensure,
    mode    => '0755',
    content => template('govuk/local_authority_import_check.erb'),
  }

  govuk::procfile::worker { $app_name:
    ensure         => $ensure,
    enable_service => $enable_procfile_worker,
  }

  unless $ensure == 'absent' {
    if $mongodb_nodes != undef {
      govuk::app::envvar::mongodb_uri { $app_name:
        hosts    => $mongodb_nodes,
        database => $mongodb_name,
        username => $mongodb_username,
        password => $mongodb_password,
      }
    }

    govuk::app::envvar::redis { $app_name:
      host => $redis_host,
      port => $redis_port,
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar {
      "${title}-PUBLISHING_API_BEARER_TOKEN":
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
      "${title}-ASSET_MANAGER_BEARER_TOKEN":
        varname => 'ASSET_MANAGER_BEARER_TOKEN',
        value   => $asset_manager_bearer_token;
      "${title}-JWT_AUTH_SECRET":
        varname => 'JWT_AUTH_SECRET',
        value   => $jwt_auth_secret;
      "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
      "${title}-GDS_SSO_OAUTH_ID":
        varname => 'GDS_SSO_OAUTH_ID',
        value   => $oauth_id;
      "${title}-GDS_SSO_OAUTH_SECRET":
        varname => 'GDS_SSO_OAUTH_SECRET',
        value   => $oauth_secret;
      "${title}-FACT_CHECK_SUBJECT_PREFIX":
        varname => 'FACT_CHECK_SUBJECT_PREFIX',
        value   => $fact_check_subject_prefix;
      "${title}-FACT_CHECK_USERNAME":
        varname => 'FACT_CHECK_USERNAME',
        value   => $fact_check_username;
      "${title}-FACT_CHECK_PASSWORD":
        varname => 'FACT_CHECK_PASSWORD',
        value   => $fact_check_password;
      "${title}-FACT_CHECK_REPLY_TO_ID":
        varname => 'FACT_CHECK_REPLY_TO_ID',
        value   => $fact_check_reply_to_id;
      "${title}-FACT_CHECK_REPLY_TO_ADDRESS":
        varname => 'FACT_CHECK_REPLY_TO_ADDRESS',
        value   => $fact_check_reply_to_address;
      "${title}-EMAIL_GROUP_DEV":
        varname => 'EMAIL_GROUP_DEV',
        value   => $email_group_dev;
      "${title}-EMAIL_GROUP_BUSINESS":
        varname => 'EMAIL_GROUP_BUSINESS',
        value   => $email_group_business;
      "${title}-EMAIL_GROUP_CITIZEN":
        varname => 'EMAIL_GROUP_CITIZEN',
        value   => $email_group_citizen;
      "${title}-EMAIL_GROUP_FORCE_PUBLISH_ALERTS":
        varname => 'EMAIL_GROUP_FORCE_PUBLISH_ALERTS',
        value   => $email_group_force_publish_alerts;
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
  }

  file { '/data/uploads/publisher/reports':
    ensure => 'directory',
    owner  => 'deploy',
    group  => 'deploy',
    mode   => '0775',
  }
}
