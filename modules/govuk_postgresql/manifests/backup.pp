# Class: govuk_postgresql::backup
#
# This class sets up local backups for PostgreSQL.
#
# === Variables
#
# [*threshold_secs*]
#  The time period in which an alert should be raised if no passive check
#  submissions have been received.
#
# [*service_desc*]
#  A simple description of the check that is alerting.
#
class govuk_postgresql::backup {
    $threshold_secs = 28 * 3600
    $service_desc = 'AutoPostgreSQL backup'

    file {'/etc/cron.daily/autopostgresqlbackup':
        mode    => '0755',
        content => template('govuk_postgresql/etc/cron.daily/autopostgresqlbackup.erb'),
    }

    @@icinga::passive_check { "check_autopostgresqlbackup-${::hostname}":
        service_description => $service_desc,
        freshness_threshold => $threshold_secs,
        host_name           => $::fqdn,
    }

    # Changes from upstream:
    #    LATEST=yes
    #    POSTBACKUP="/etc/postgresql-backup-post"
    #    PREBACKUP="/etc/postgresql-backup-pre"
    file {'/etc/default/autopostgresqlbackup':
        source  => 'puppet:///modules/govuk_postgresql/etc/default/autopostgresqlbackup',
        require => File['/etc/cron.daily/autopostgresqlbackup'],
    }

    include backup::client
    file {'/etc/postgresql-backup-post':
        mode    => '0755',
        source  => 'puppet:///modules/govuk_postgresql/etc/postgresql-backup-post',
        require => Class['backup::client'],
    }
    file {'/etc/postgresql-backup-pre':
        mode   => '0755',
        source => 'puppet:///modules/govuk_postgresql/etc/postgresql-backup-pre',
    }

}
