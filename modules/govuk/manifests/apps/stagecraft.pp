# == Class: govuk::apps::stagecraft
#
# Stagecraft is the API service for the Performance Platform.
#
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
class govuk::apps::stagecraft (
  $enabled = false,
) {
  if $enabled {
    package { 'libffi-dev':
      ensure => present,
    }

    govuk::app { 'stagecraft':
      app_type           => 'procfile',
      port               => 3103,
      vhost_ssl_only     => true,
      health_check_path  => '/_status',
      log_format_is_json => true;
    }
  }
}
