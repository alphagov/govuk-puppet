# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::signon(
  $port = 3016,
  $enable_procfile_worker = true,
  $devise_secret_key = undef,
  $enable_logstream = false,
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

  govuk::procfile::worker { $app_name:
    enable_service => $enable_procfile_worker,
  }

  if $devise_secret_key != undef {
    govuk::app::envvar { "${title}-DEVISE_SECRET_KEY":
      app     => $app_name,
      varname => 'DEVISE_SECRET_KEY',
      value   => $devise_secret_key,
    }
  }
}
