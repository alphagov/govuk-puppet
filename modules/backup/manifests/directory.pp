define backup::directory (
    $directory,
    $frequency = 'daily',
    $versioned = false,
    $host_name = $::hostname
    ) {

    file { "/etc/backup/${frequency}/directory_${host_name}_${name}":
        content => template('backup/directory.erb'),
        mode    => '0755',
    }
}
