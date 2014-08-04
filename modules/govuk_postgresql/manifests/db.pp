# == Define: govuk_postgresql::db
#
# A wrapper to setup Postgres databases in a standard way with sensible
# defaults.
#
# The title of the resource can be a valid database name, however if it
# is not valid as a database name, you should pass the $database param.
#
# === Parameters
#
# [*user*]
# The name of the user who will have access to this database
#
# [*password*]
# The password (in plaintext) for this user. It will be wrapped in a
# call to postgresql_password to enable it to be passed in to the
# postgresql::server::db type.
#
# [*database*]
# An optional name for this database. It will default to the resource title.
# Default: $title
#
# [*owner*]
# An optional owner for this database. It will default to $user, however this
# differs from postgresql::server::db which has a default of 'postgres'
# Default: $user
#
# [*encoding*]
# An optional database encoding.
# Default: UTF8
#
# [*extensions*]
# An optional array of Postgresql Extensions to load for this database.
# Default: []
define govuk_postgresql::db (
    $user,
    $password,
    $database   = undef,
    $owner      = undef,
    $encoding   = 'UTF8',
    $extensions = [],
) {

    if ($database == undef) {
        $db_name = $title
    } else {
        $db_name = $database
    }
    if ($owner == undef) {
        $db_owner = $user
    } else {
        $db_owner = $owner
    }
    $password_hash = postgresql_password($user, $password)
    if ! defined(Postgresql::Server::Role[$user]) {
        postgresql::server::role { $user:
            password_hash => $password_hash,
        }
    }
    postgresql::server::db {$db_name:
        encoding => $encoding,
        owner    => $db_owner,
        password => $password_hash,
        user     => $user,
        require  => [Class['govuk_postgresql::server'], Postgresql::Server::Role[$user]],
    }

    # If we asked for any extensions, install them here
    validate_array($extensions)
    if (!empty($extensions)) {
        $temp_extensions = prefix($extensions,"${db_name}:")
        govuk_postgresql::extension { $temp_extensions: }
    }
}
