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
define govuk::app::envvar::mongodb_uri (
  $hosts,
  $database,
) {

  validate_array($hosts)
  if ($hosts == []) {
    fail 'must pass hosts'
  }

  $hosts_string = join($hosts, ',')
  govuk::app::envvar { "${title}-MONGODB_URI":
    app     => $title,
    varname => 'MONGODB_URI',
    value   => "mongodb://${hosts_string}/${database}",
  }
}
