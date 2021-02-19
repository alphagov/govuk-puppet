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
# [*gdal_version*]
#   The version of the GDAL library to install for mapit
#
# [*geos_version*]
#   The version of the GEOS library to install for mapit
#
# [*proj_version*]
#   The version of the PROJ library to install for mapit
#
class govuk::apps::mapit (
  $enabled = false,
  $port,
  $db_password,
  $django_secret_key = undef,
  $sentry_dsn = undef,
  $gdal_version,
  $geos_version = '3.9.0',
  $proj_version = '4.9.3',
) {
  if $enabled {
    govuk::app { 'mapit':
      app_type                           => 'procfile',
      create_pidfile                     => false,
      port                               => $port,
      vhost_ssl_only                     => true,
      health_check_path                  => '/',
      nagios_memory_warning              => 1200,
      nagios_memory_critical             => 2000,
      log_format_is_json                 => false,
      sentry_dsn                         => $sentry_dsn,
      monitor_unicornherder              => true,
      local_tcpconns_established_warning => 16,
    }

    include ::postgresql::server::postgis # Required to load the PostGIS extension for mapit

    $deb_absent_packages = [
      'libgdal-dev',
      'libgdal1h',
      'libgeos-c1',
      'libgeos-dev',
      'libproj0',
      'libproj-dev',
      'proj-bin',
      'proj-data',
    ]

    ensure_packages($deb_absent_packages, {'ensure' => 'absent'})

    $deb_packages = [
      'libhdf4-0-alt',
      'libnetcdf-dev',
      'unixodbc-dev',
    ]

    ensure_packages($deb_packages, {'ensure' => 'installed'})

    include postgresql::lib::devel

    include gdal::repo
    package { 'gdal':
      ensure  => $gdal_version,
      require => Class['gdal::repo'],
    }

    package { 'geos':
      ensure  => $geos_version,
      require => Apt::Source['postgis'],
    }

    package { 'proj':
      ensure  => $proj_version,
      require => Apt::Source['postgis'],
    }

    govuk_postgresql::db { 'mapit':
      user                => 'mapit',
      password            => $db_password,
      extensions          => ['plpgsql', 'postgis'],
      enable_in_pgbouncer => false,
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

  if ($::mapit_data_present == '0') {


    file { '/etc/govuk/import_mapit_data.sh':
      ensure => file,
      source => 'puppet:///modules/govuk/etc/govuk/import_mapit_data.sh',

    }
    exec { 'populate mapit database':
      command => '/bin/bash /etc/govuk/import_mapit_data.sh 2>&1 | logger',
    }
  }

}
