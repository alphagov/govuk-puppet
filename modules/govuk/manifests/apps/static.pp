# govuk::apps::static
#
# The GOV.UK static application -- serves static assets and templates
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
#
# [*draft_environment*]
#   A boolean to indicate whether we are in the draft environment.
#   Sets the environment variable DRAFT_ENVIRONMENT to 'true' if
#   true, does not set it if false.
#   Default: false
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::static(
  $vhost,
  $port = 3013,
  $errbit_api_key = undef,
  $draft_environment = false,
  $secret_key_base = undef,
) {
  $app_domain = hiera('app_domain')
  $website_root = hiera('website_root')
  $asset_manager_host = "asset-manager.${app_domain}"
  $enable_ssl = hiera('nginx_enable_ssl', true)
  $app_name = 'static'

  govuk::app { $app_name:
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/templates/wrapper.html.erb',
    log_format_is_json    => true,
    nginx_extra_config    => template('govuk/static_extra_nginx_config.conf.erb'),
    asset_pipeline        => true,
    asset_pipeline_prefix => $app_name,
    vhost                 => $vhost,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  if $errbit_api_key {
    govuk::app::envvar { "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key,
    }
  }

  if $draft_environment {
    govuk::app::envvar {
      "${title}-DRAFT_ENVIRONMENT":
        varname => 'DRAFT_ENVIRONMENT',
        value   => '1';
    }
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }
}
