class postgres::postgis(
  $ensure=present) {

  case $::lsbdistcodename {
    'lucid' : {
        $version     = '8.4'
        $postgis_dir = "/usr/share/postgresql/${version}/contrib"
        $geography   = false
    }
    'precise': {
        $version     = '9.1'
        $postgis_dir = "/usr/share/postgresql/${version}/contrib/postgis-1.5"
        $geography   = true
    }
    default: {
        $version     = '9.1'
        $postgis_dir = "/usr/share/postgresql/${version}/contrib/postgis-1.5"
        $geography   = true
    }
  }

  case $ensure {
    present: {
        package {[
            'binutils',
            'gdal-bin',
            'libproj-dev',
            "postgresql-${version}-postgis",
            "postgresql-server-dev-${version}"
            ]:
            ensure  => present,
        }
        postgres::database { 'template_postgis':
            ensure    => present,
            encoding  => 'UTF8',
            template  => 'template0',
            before    => Exec['Set template_postgis to be a template'],
        }



        exec {'Set template_postgis to be a template':
            command   => 'psql -qd postgres -c "UPDATE pg_database \
                          SET datistemplate=\'true\' \
                          WHERE datname=\'template_postgis\';"',
            user      => 'postgres',
            onlyif    => 'test $(psql -tA -c "SELECT datistemplate \
                          FROM pg_database \
                          WHERE datname=\'template_postgis\';") = f',
            logoutput => 'on_failure',
        }

        exec {'Import the PostGIS SQL to template_postgis':
            command   => "psql -qd template_postgis -f ${postgis_dir}/postgis.sql",
            user      => 'postgres',
            require   => Exec['Set template_postgis to be a template'],
            logoutput => 'on_failure',
            unless    => 'test $(psql -tA -d template_postgis -c "select count(*) from pg_proc where proname = \'st_minimumboundingcircle\';") = 2',

        }

        exec {'Import the Spatial Refs to template_postgis':
            command   => "psql -qd template_postgis -f ${postgis_dir}/spatial_ref_sys.sql",
            user      => 'postgres',
            require   => Exec['Import the PostGIS SQL to template_postgis'],
            logoutput => 'on_failure',
            unless    => 'test $(psql -tA -d template_postgis -c "select count(*)=0 \
                          from spatial_ref_sys") = f',
        }

        exec {'Grant access to PostGIS data':
            command   => 'psql -qd template_postgis -c "GRANT ALL ON geometry_columns \
                          TO PUBLIC; GRANT ALL ON spatial_ref_sys TO PUBLIC;"',
            user      => 'postgres',
            require   => Exec['Import the Spatial Refs to template_postgis'],
            unless    => 'psql -tA -d template_postgis -c "\\z geometry_columns" | grep public',
            logoutput => 'on_failure',
        }
        if $geography {
            exec {'Grant access to geography_columns':
                command   => 'psql -qd template_postgis -c "GRANT ALL ON \
                              geography_columns TO PUBLIC;"',
                user      => 'postgres',
                require   => Exec['Import the Spatial Refs to template_postgis'],
                unless    => 'psql -tA -d template_postgis -c "\\z geography_columns" | grep public',
                logoutput => 'on_failure',
            }
        }
        exec {'Fix the datum of srid 29902':
            command   => "psql -qd template_postgis -c \"UPDATE spatial_ref_sys
                          SET proj4text=proj4text||'+datum=ire65'
                          WHERE srid=29902;\"",
            user      => 'postgres',
            unless    => 'test $(psql -d template_postgis -tA -c "select count(*)=1 from \
                          spatial_ref_sys where srid=29902 and proj4text \
                          LIKE \'%datum%\';") = t',
            require   => Exec['Import the Spatial Refs to template_postgis'],
        }
    }

    default: {
        fail "Invalid 'ensure' value  '$ensure' for postgres::gis"
    }
  }
}
