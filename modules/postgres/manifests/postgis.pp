class postgres::postgis {
    $version = '9.1'

    include postgres::ubuntu
    package {[
        'binutils',
        'gdal-bin',
        'libproj-dev',
        "postgresql-${version}-postgis",
        "postgresql-server-dev-${version}"
        ]:
        ensure  => present,
    }
}
