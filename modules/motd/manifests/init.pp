class motd {
    # This package creates a dynamic motd generated on ssh login
    package { 'update-motd': ensure => installed}

    # Removing the default files created by update-motd
    file { '/etc/update-motd.d/':
        ensure  => directory,
        # Clear all scripts from this dir that are not puppet managed
        purge   => true,
        recurse => true,
        require => Package['update-motd'],
    }
}
