class sshd::config {
    file {'/etc/ssh/sshd_config':
        content => template('sshd/sshd_config.erb'),
        mode    => '0400',
    }
}
