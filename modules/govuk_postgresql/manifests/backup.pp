# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_postgresql::backup {
    package {'autopostgresqlbackup':
        ensure => present,
    }

    # Changes from upstream:
    #    LATEST=yes
    #    POSTBACKUP="/etc/postgresql-backup-post"
    #    PREBACKUP="/etc/postgresql-backup-pre"
    file {'/etc/default/autopostgresqlbackup':
        source  => 'puppet:///modules/govuk_postgresql/etc/default/autopostgresqlbackup',
        require => Package['autopostgresqlbackup'],
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
