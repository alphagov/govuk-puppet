# == Define: govuk::app::envvar::redis
#
# Defines Redis env vars for an app.
#
# === Parameters
#
# [*host*]
#   The Redis host.
#   Default: "127.0.0.1"
#
# [*port*]
#   The Redis port.
#   Default: 6379
#
define govuk::app::envvar::redis (
  $host = '127.0.0.1',
  $port = 6379,
) {

  Govuk::App::Envvar {
    app => $title,
  }

  govuk::app::envvar {
    "${title}-redis_host":
      varname => 'REDIS_HOST',
      value   => $host;
    "${title}-redis_port":
      varname => 'REDIS_PORT',
      value   => $port;
    "${title}-redis_url":
      varname => 'REDIS_URL',
      value   => "redis://${host}:${port}";
  }
}
