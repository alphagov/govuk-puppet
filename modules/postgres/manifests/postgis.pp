class postgres::postgis {

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
