# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_postgresql::backup {
    file {'/usr/local/sbin/autopostgresqlbackup':
        source  => 'puppet:///modules/govuk_postgresql/usr/local/sbin/autopostgresqlbackup',
    }

    # FIXME: Remove when the autopostgresqlbackup has been removed from all environments
    package {'autopostgresqlbackup':
        ensure => absent,
    }

    # Changes from upstream:
    #    LATEST=yes
    #    POSTBACKUP="/etc/postgresql-backup-post"
    #    PREBACKUP="/etc/postgresql-backup-pre"
    file {'/etc/default/autopostgresqlbackup':
        source  => 'puppet:///modules/govuk_postgresql/etc/default/autopostgresqlbackup',
        require => File['/usr/local/sbin/autopostgresqlbackup'],
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
