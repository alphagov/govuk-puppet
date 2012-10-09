define backup::directory (
    $directory,
    $host_name,
    $fq_dn,
    $frequency = 'daily',
    $versioned = false,
    ) {

    file { "/etc/backup/${frequency}/directory_${name}":
        content => template('backup/directory.erb'),
        mode    => '0755',
    }
}
