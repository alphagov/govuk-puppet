# Class: govuk_postgresql::backup
#
# This class sets up local backups for PostgreSQL.
#
# === Parameters
#
# [*auto_postgresql_backup_hour*]
#  The hour(s) that auto_postgresql_backup(s) run(s).
#
# [*auto_postgresql_backup_minute*]
#  The minute(s) that auto_postgresql_backup(s) run(s).
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
# [*alert_hostname*]
#   The hostname of the alert service, to send ncsa notifications.
#
# [*ensure*]
#   Determines whether backup is enabled or not. Valid values are:
#   1. 'present' - backup is active
#   2. 'absent' - backup is inactive
#
class govuk_postgresql::backup (
  $auto_postgresql_backup_hour = 6,
  $auto_postgresql_backup_minute = 0,
  $alert_hostname = 'alert.cluster',
  $ensure = 'present',
) {

    $threshold_secs = 28 * 3600
    $service_desc = 'AutoPostgreSQL backup'

    file {'/usr/local/bin/autopostgresqlbackup':
        ensure  => $ensure,
        mode    => '0755',
        content => template('govuk_postgresql/usr/local/bin/autopostgresqlbackup.erb'),
        require => File['/etc/default/autopostgresqlbackup'],
    }

    cron::crondotdee { 'auto_postgresql_backup':
        ensure  => $ensure,
        command => '/usr/local/bin/autopostgresqlbackup',
        hour    => $auto_postgresql_backup_hour,
        minute  => $auto_postgresql_backup_minute,
    }

    @@icinga::passive_check { "check_autopostgresqlbackup-${::hostname}":
        ensure              => $ensure,
        service_description => $service_desc,
        freshness_threshold => $threshold_secs,
        host_name           => $::fqdn,
        notes_url           => monitoring_docs_url(backup-passive-checks),
    }

    # Changes from upstream:
    #    LATEST=yes
    #    POSTBACKUP="/etc/postgresql-backup-post"
    #    PREBACKUP="/etc/postgresql-backup-pre"
    file {'/etc/default/autopostgresqlbackup':
        ensure => $ensure,
        source => 'puppet:///modules/govuk_postgresql/etc/default/autopostgresqlbackup',
    }

    include backup::client
    file {'/etc/postgresql-backup-post':
        ensure  => $ensure,
        mode    => '0755',
        source  => 'puppet:///modules/govuk_postgresql/etc/postgresql-backup-post',
        require => Class['backup::client'],
    }
    file {'/etc/postgresql-backup-pre':
        ensure => $ensure,
        mode   => '0755',
        source => 'puppet:///modules/govuk_postgresql/etc/postgresql-backup-pre',
    }

}
