# == Define: govuk::app::envvar::mongodb_uri
#
# Defines a MONGODB_URI env var for an app. This constructs the URL from the
# given parameters.
#
# === Parameters
#
# [*hosts*]
#   An array of hostnames of the database servers.
#
# [*database*]
#   The database name.
#
# [*username*]
#   Username used in connection string
#
# [*password*]
#   Password used in connection string
#
# [*params*]
#   URL encoded arguments for connection string ie 'ssl=true&ssl_verify=false'
define govuk::app::envvar::mongodb_uri (
  $hosts,
  $database,
  $username = '',
  $password = '',
  $params = '',
  $varname = 'MONGODB_URI',
) {

  validate_array($hosts)
  if ($hosts == []) {
    fail 'must pass hosts'
  }

  $hosts_string = join($hosts, ',')

  if ($username != '') {
    $auth = "${username}:${password}@"
  }

  if ($params != '') {
    $args = "?${params}"
  }

  govuk::app::envvar { "${title}-MONGODB_URI":
    app     => $title,
    varname => $varname,
    value   => "mongodb://${auth}${hosts_string}/${database}${args}",
  }
}
