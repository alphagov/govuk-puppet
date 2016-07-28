# == Class: govuk::apps::signon
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
#   Whether to enable the procfile worker. Typically used to disable the worker
#   on the dev VM.
#
# [*devise_secret_key*]
#   The secret key used by Devise to generate random tokens.
#
# [*redis_url*]
#   The URL used by the Sidekiq queue to connect to the backing Redis instance.
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
class govuk::apps::signon(
  $port = '3016',
  $enable_procfile_worker = true,
  $devise_secret_key = undef,
  $redis_host = 'redis-1.backend',
  $redis_port = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
) {
  $app_name = 'signon'

  govuk::app { $app_name:
    app_type               => 'rack',
    port                   => $port,
    vhost_ssl_only         => true,
    health_check_path      => '/users/sign_in',
    legacy_logging         => false,
    vhost_aliases          => ['signonotron'],
    asset_pipeline         => true,
    deny_framing           => true,
    nagios_memory_warning  => $nagios_memory_warning,
    nagios_memory_critical => $nagios_memory_critical,
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

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  include govuk_postgresql::client #installs libpq-dev package needed for pg gem
}
