# Wrapper for all the things needed for a postgres server
class govuk_postgresql::server {
    class {'postgresql::server':
        listen_addresses => '*',
    }

    @ufw::allow { 'allow-postgresql-from-all':
        port => 5432,
    }
}
