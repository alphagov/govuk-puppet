# == Define: govuk::app::envvar::redis
#
# Defines Redis env vars for an app.
#
# === Parameters
#
# [*app*]
#   An optional GOV.UK app that the env vars are for.
#
# [*prefix*]
#   An optional prefix for the env vars.
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
  $app    = undef,
  $prefix = undef,
  $host   = '127.0.0.1',
  $port   = '6379',
) {

  Govuk::App::Envvar {
    app => pick($app, $title),
  }

  $host_key = join(delete_undef_values([$prefix, 'redis', 'host']), '_')
  $port_key = join(delete_undef_values([$prefix, 'redis', 'port']), '_')
  $url_key  = join(delete_undef_values([$prefix, 'redis', 'url']), '_')

  govuk::app::envvar {
    "${title}-${host_key}":
      varname => upcase($host_key),
      value   => $host;
    "${title}-${port_key}":
      varname => upcase($port_key),
      value   => $port;
    "${title}-${url_key}":
      varname => upcase($url_key),
      value   => "redis://${host}:${port}";
  }
}
