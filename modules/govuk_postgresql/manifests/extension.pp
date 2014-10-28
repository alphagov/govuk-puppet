# == Define: govuk_postgresql::extension
#
# A simple wrapper for an exec that will load a Postgres extension into
# a database
#
# The title of this resource must be the name of the database and the
# extension to load into it, colon separated
#
# === Parameters
#
# [*db*]
# The database to install the extension for
#
define govuk_postgresql::extension {
    $extracted_title = split($title,':')
    if (size($extracted_title) < 2) {
        fail("Could not extract db_name:extension from ${title}")
    } else {
        $db = $extracted_title[0]
        $extension = $extracted_title[1]
        exec {"Load ${extension} for Postgres DB: ${db}":
            command => "psql -d ${db} -c 'CREATE EXTENSION IF NOT EXISTS ${extension}'",
            unless  => "psql -d ${db} -c '\\dx' | grep -q ${extension}",
            user    => 'postgres',
            require => [Class['postgresql::server::contrib'], Postgresql::Server::Db[$db]],
        }
    }
}
