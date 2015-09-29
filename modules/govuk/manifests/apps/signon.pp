# govuk::apps::signon
#
# The GOV.UK Signon application -- single sign-on service for GOV.UK
#
# === Parameters
#
# [*port*]
#   The port that it is served on.
#   Default: 3016
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker. Typically sued to disable the worker
#   on the dev VM.
#
# [*devise_secret_key*]
#   The secret key used by Devise to generate random tokens.
#
# [*redis_url*]
#   The URL used by the Sidekiq queue to connect to the backing Redis instance.
#
class govuk::apps::signon(
  $port = 3016,
  $enable_procfile_worker = true,
  $devise_secret_key = undef,
  $enable_logstream = false,
  $redis_url = undef,
) {
  $app_name = 'signon'

  $ensure_logstream = $enable_logstream ? {
    true  => 'present',
    false => 'absent'
  }

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/users/sign_in',
    log_format_is_json => true,
    vhost_aliases      => ['signonotron'],
    logstream          => $ensure_logstream,
    asset_pipeline     => true,
    deny_framing       => true,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::procfile::worker { $app_name:
    enable_service => $enable_procfile_worker,
  }

  if $devise_secret_key != undef {
    govuk::app::envvar { "${title}-DEVISE_SECRET_KEY":
      varname => 'DEVISE_SECRET_KEY',
      value   => $devise_secret_key,
    }
  }

  if $redis_url != undef {
    govuk::app::envvar { "${title}-REDIS_URL":
      varname => 'REDIS_URL',
      value   => $redis_url,
    }
  }
}
