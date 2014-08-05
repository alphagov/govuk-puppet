# Wrapper for all the things needed for a postgres server
class govuk_postgresql::server (
    $backup = true,
    $listen_addresses = '*',
) {
    class {'postgresql::server':
        listen_addresses => $listen_addresses,
    }

    @ufw::allow { 'allow-postgresql-from-all':
        port => 5432,
    }

    if ($backup) {
        include govuk_postgresql::backup
    }
}
