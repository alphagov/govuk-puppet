# Wrapper for all the things needed for a postgres server
class govuk_postgresql::server (
    $backup = true,
) {
    class {'postgresql::server':
        listen_addresses => '*',
    }

    @ufw::allow { 'allow-postgresql-from-all':
        port => 5432,
    }

    if ($backup) {
        include govuk_postgresql::backup
    }
}
