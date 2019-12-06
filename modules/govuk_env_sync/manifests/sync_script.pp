# == Class: govuk_env_sync::sync_script
#
# Install the sync script
#
class govuk_env_sync::sync_script {
  sudo::conf {
    'govuk-env-sync-commands':
      ensure  => 'present',
      content => 'govuk-backup ALL=(root,postgres) NOPASSWD:/usr/bin/psql,/usr/bin/createdb,/usr/bin/dropdb,/usr/bin/dropuser,/usr/bin/pg_restore,/usr/bin/mysql,/usr/bin/mysqldump,/usr/bin/pg_dump';
  }

  # sync script
  file { '/usr/local/bin/govuk_env_sync.sh':
    ensure => present,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/govuk_env_sync/govuk_env_sync.sh',
  }

  # Data-scrubbing SQL scripts. These are dependencies of the sync script.
  file { "${govuk_env_sync::conf_dir}/transformation_sql":
    ensure       => 'directory',
    recurse      => true,
    mode         => '0644',
    owner        => 'root',
    group        => 'root',
    sourceselect => 'all',
    source       => 'puppet:///modules/govuk_env_sync/transformation_sql',
  }
}
