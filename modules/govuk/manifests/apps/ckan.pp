# == Class: govuk::apps::ckan
##
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
# [*port*]
#   What port should the app run on?
#
# [*db_hostname*]
#   The postgres instance for CKAN to connect to
#
# [*db_username*]
#   The username for the postgresql role
#
# [*db_password*]
#   The password for the postgresql role
#
# [*db_name*]
#   The database that CKAN should use
#
# [*redis_host*]
#   The Redis host that CKAN should use
#
# [*redis_port*]
#   The Redis port that CKAN should use
#
# [*secret*]
#   The secret token that CKAN uses for session encryption
#
class govuk::apps::ckan (
  $enabled                   = false,
  $port                      = '3108',
  $db_hostname               = undef,
  $db_username               = 'ckan',
  $db_password               = 'foo',
  $db_name                   = 'ckan_production',
  $redis_host                = undef,
  $redis_port                = '6379',
  $secret                    = undef,
  $ckan_site_url             = undef,
  $gunicorn_worker_processes = '1',
) {
  $ckan_home = '/var/ckan'
  $ckan_ini  = "${ckan_home}/ckan.ini"

  if $enabled {
    govuk::app { 'ckan':
      app_type           => 'bare',
      command            => "unicornherder --gunicorn-bin ./venv/bin/gunicorn -p /var/run/ckan/unicornherder.pid -- --pythonpath ${ckan_home} wsgi_app:application --bind 127.0.0.1:${port} --workers ${gunicorn_worker_processes}",
      port               => $port,
      vhost_ssl_only     => true,
      health_check_path  => '/healthcheck',
      log_format_is_json => false,
    }

    Govuk::App::Envvar {
      app => 'ckan',
    }

    govuk::app::envvar {
      "${title}-CKAN_INI":
        varname => 'CKAN_INI',
        value   => $ckan_ini;
    }

    file { $ckan_home:
      ensure => directory,
      owner  => 'deploy',
      group  => 'deploy',
    } ->

    file { $ckan_ini:
      ensure  => file,
      content => template('govuk/ckan/ckan.ini.erb'),
      owner   => 'deploy',
      group   => 'deploy',
      notify  => Service['ckan'],
    } ->

    file { "${ckan_home}/wsgi_app.py":
      ensure  => file,
      content => template('govuk/ckan/wsgi_app.py.erb'),
      owner   => 'deploy',
      group   => 'deploy',
      notify  => Service['ckan'],
    } ->

    file { "${ckan_home}/who.ini":
      ensure  => file,
      content => template('govuk/ckan/who.ini.erb'),
      owner   => 'deploy',
      group   => 'deploy',
      notify  => Service['ckan'],
    }

    file { "${ckan_home}/default":
      ensure => directory,
      owner  => 'deploy',
      group  => 'deploy',
    }
  }
}
