# == Class: govuk::apps::transition
#
# Managing mappings (eg redirects) for sites moving to GOV.UK.
#
# === Parameters
#
# [*port*]
#   The port that transition is served on.
#   Default: 3044
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*oauth_id*]
#   The Signon OAuth identifier for this app
#
# [*oauth_secret*]
#   The Signon OAuth secret for this app
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::transition(
  $port = '3044',
  $enable_procfile_worker = true,
  $oauth_id = undef,
  $oauth_secret = undef,
  $secret_key_base = undef
) {
  $app_name = 'transition'

  include govuk_postgresql::client
  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    deny_framing       => true,
    asset_pipeline     => true,
  }

  govuk::procfile::worker { $app_name:
    enable_service => $enable_procfile_worker,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  if $secret_key_base {
    govuk::app::envvar {
      "${title}-OAUTH_ID":
        varname => 'OAUTH_ID',
        value   => $oauth_id;
      "${title}-OAUTH_SECRET":
        varname => 'OAUTH_SECRET',
        value   => $oauth_secret;
      "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
    }
  }

}
