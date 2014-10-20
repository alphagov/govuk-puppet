# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::transition_postgres(
  $port = 3083,
  $enable_procfile_worker = true,
  $enabled = false,
) {
  if $enabled {
    include govuk_postgresql::client
    govuk::app { 'transition-postgres':
      app_type           => 'rack',
      port               => $port,
      vhost_ssl_only     => true,
      health_check_path  => '/',
      log_format_is_json => true,
      vhost_protected    => false,
      deny_framing       => true,
    }

    govuk::procfile::worker {'transition-postgres':
      enable_service => $enable_procfile_worker,
    }
  }
}
