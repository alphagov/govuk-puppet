# == Class: govuk::apps::mapit
##
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
# [*port*]
#   What port should the app run on?
#
# [*db_password*]
#   The password for the mapit postgresql role
#
class govuk::apps::mapit (
  $enabled = false,
  $port    = 3108,
  $db_password,
) {
  if $enabled {
    govuk::app { 'mapit':
      app_type           => 'procfile',
      port               => $port,
      vhost_ssl_only     => true,
      health_check_path  => '/',
      log_format_is_json => false;
    }

    govuk_postgresql::db { 'mapit':
      user       => 'mapit',
      password   => $db_password,
      extensions => ['plpgsql', 'postgis'],
    }
  }
}
