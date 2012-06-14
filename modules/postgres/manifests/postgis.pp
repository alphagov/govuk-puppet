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
            overwrite => true,
            before    => Exec['Set template_postgis to be a template']
        }


        exec {'Set template_postgis to be a template':
            command   => 'psql -qd postgres -c "UPDATE pg_database \
                          SET datistemplate=\'true\' \
                          WHERE datname=\'template_postgis\';"',
            user      => 'postgres',
            logoutput => 'on_failure',
        }

        exec {'Import the PostGIS SQL to template_postgis':
            command   => "psql -qd template_postgis -f ${postgis_dir}/postgis.sql",
            user      => 'postgres',
            require   => Exec['Set template_postgis to be a template'],
            logoutput => 'on_failure',

        }

        exec {'Import the Spatial Refs to template_postgis':
            command   => "psql -qd template_postgis -f ${postgis_dir}/spatial_ref_sys.sql",
            user      => 'postgres',
            require   => Exec['Import the PostGIS SQL to template_postgis'],
            logoutput => 'on_failure',
        }

        exec {'Grant access to PostGIS data':
            command   => 'psql -qd template_postgis -c "GRANT ALL ON geometry_columns \
                          TO PUBLIC; GRANT ALL ON spatial_ref_sys TO PUBLIC;"',
            user      => 'postgres',
            require   => Exec['Import the Spatial Refs to template_postgis'],
            logoutput => 'on_failure',
        }
        if $geography {
            exec {'Grant access to geography_columns':
                command   => 'psql -qd template_postgis -c "GRANT ALL ON \
                              geography_columns TO PUBLIC;"',
                user      => 'postgres',
                require   => Exec['Import the Spatial Refs to template_postgis'],
                logoutput => 'on_failure',
            }
        }
    }

    default: {
        fail "Invalid 'ensure' value  '$ensure' for postgres::gis"
    }
  }
}
