# == Define: govuk::app::envvar::database_url
#
# Defines a DATABASE_URL env var for an app. This constructs the URL from the
# given parameters, taking care of escaping the password.
#
# === Parameters
#
# [*type*]
#   The database type. This becomes the scheme in the database URL.
#
# [*username*]
#   The database username.
#
# [*password*]
#   The database password.  This value will be escaped before being inserted in
#   the URL.
#
# [*host*]
#   The hostname of the database server.
#
# [*database*]
#   The database name.
#
define govuk::app::envvar::database_url (
  $type,
  $username,
  $password,
  $host,
  $database,
) {

  $escaped_password = inline_template('<%= CGI.escape(@password) %>')
  govuk::app::envvar { "${title}-DATABASE_URL":
    app     => $title,
    varname => 'DATABASE_URL',
    value   => "${type}://${username}:${escaped_password}@${host}/${database}",
  }
}
