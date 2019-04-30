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
# [*django_secret_key*]
#   The key for Django to use when signing/encrypting sessions.
#
# [*sentry_dsn*]
#   Configuration for Sentry error reporting
#
class govuk::apps::mapit (
  $enabled = false,
  $port    = '3108',
  $db_password,
  $django_secret_key = undef,
  $sentry_dsn = undef,
  $gdal_version,
) {
  if $enabled {
    govuk::app { 'mapit':
      app_type              => 'procfile',
      create_pidfile        => false,
      port                  => $port,
      vhost_ssl_only        => true,
      health_check_path     => '/',
      log_format_is_json    => false,
      sentry_dsn            => $sentry_dsn,
      monitor_unicornherder => true,
    }

    govuk_postgresql::db { 'mapit':
      user                => 'mapit',
      password            => $db_password,
      extensions          => ['plpgsql', 'postgis'],
      enable_in_pgbouncer => false,
    }

    class { 'postgresql::server::postgis': }

    package {
      [
        # These packages are recommended when installing geospatial
        # support for Django:
        # https://docs.djangoproject.com/en/1.8/ref/contrib/gis/install/geolibs/
        'binutils',
        'libproj-dev',
      ]:
      ensure => present,
    }

    # Install postgrest developments dependencies
    include postgresql::lib::devel

    include gdal::repo
    package { 'gdal':
      ensure  => $gdal_version,
      require => Class['gdal::repo'],
    }
  }

  Govuk::App::Envvar {
    app => 'mapit',
  }

  govuk::app::envvar {
    "${title}-DB_PASSWORD":
        varname => 'MAPIT_DB_PASS',
        value   => $db_password;
    "${title}-DJANGO_SECRET_KEY":
        varname => 'DJANGO_SECRET_KEY',
        value   => $django_secret_key;
  }
}
