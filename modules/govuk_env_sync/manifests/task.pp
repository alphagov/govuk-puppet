# == Custom resource type: govuk_env_sync::task
#
# Creates a configuration file and cron-job, parameterising the govuk_env_sync.sh
# from data provided in hieradata govuk_env_sync::tasks:
#
# [*hour*]
#   The hour when to run the cron job (crontab format, globs ok)
#
# [*minute*]
#   The minute when to run the cron job (crontab format, globs ok)
#
# [*action*]
#   'push' or 'pull' with respect to the storage backend (push=dump+push,etc)
#
# [*dbms*]
#   One of: 'mongo' (more to come)
#   Please note: This needs to correspond to script names, eg. dump_mongo()
#
# [*storagebackend*]
#   One of: 's3' (more to come)
#   Please note: This needs to correspond to script names, eg. push_s3()
#
# [*temppath*]
#   Where to write dumps and compress/decompress data
#
# [*database*]
#   Name of the database to dump/push/pull/restore
#
# [*url*]
#   Name of the bucket/server used as storage backend
#
# [*path*]
#   Name of the prefix/path used in the storage backend
#
# [*name*]
#   Descriptive name for configuration, used for config file name
#
# [*ensure*]
#   One of 'present', 'disabled' or 'absent' to control the task.
#   Default: 'present'
#
# [*transformation_sql_filename*]
#   Optional filename of a SQL script to run as part of the restore transaction
#   after the data has been loaded. This is intended for scrubbing user data
#   when restoring to the Integration environment. The corresponding file must
#   exist in the files/transformation_sql directory of the govuk_env_sync
#   Puppet module.
#   Default: ''
#
# [*pre_dump_transformation_sql_filename*]
#   Optional filename of a SQL script to run before dumping a MySQL database.
#   Intended for data scrubbing / anonymisation when dumping the Whitehall
#   database from Staging. Unlike for Postgres, the script is *not* wrapped in
#   a transaction. The corresponding file must exist in the
#   files/transformation_sql directory of the govuk_env_sync Puppet module.
#   Default: ''
#
define govuk_env_sync::task(
  $hour,
  $minute,
  $action,
  $dbms,
  $storagebackend,
  $temppath,
  $database,
  $url,
  $path,
  $ensure = 'present',
  $transformation_sql_filename = '',
  $pre_dump_transformation_sql_filename = '',
) {
  $general_ensure = $ensure ? {
    'disabled' => 'absent',
    default => $ensure,
  }

  $config_ensure = $ensure ? {
    'disabled' => 'present',
    default => $ensure,
  }

  require govuk_env_sync::aws_auth
  require govuk_env_sync::log
  require govuk_env_sync::sync_script

  file { "${govuk_env_sync::conf_dir}/${title}.cfg":
    ensure  => $config_ensure,
    mode    => '0644',
    owner   => $govuk_env_sync::user,
    group   => $govuk_env_sync::user,
    content => template('govuk_env_sync/govuk_env_sync_job.conf.erb'),
  }

  ensure_resource('file', $temppath, {
    ensure => 'directory',
    mode   => '0775',
    owner  => $govuk_env_sync::user,
    group  => $govuk_env_sync::user,
  })

  $synccommand = shellquote([
    '/usr/bin/ionice','-c','2','-n','6',
    '/usr/local/bin/with_reboot_lock',
    '/usr/bin/envdir',"${govuk_env_sync::conf_dir}/env.d",
    '/usr/local/bin/govuk_env_sync.sh','-f',"${govuk_env_sync::conf_dir}/${title}.cfg",
    ])

  cron { $name:
    ensure  => $general_ensure,
    command => $synccommand,
    user    => $govuk_env_sync::user,
    hour    => $hour,
    minute  => $minute,
    require => File["${govuk_env_sync::conf_dir}/${title}.cfg"],
  }

  # monitoring
  $threshold_secs = 28 * 3600
  $service_desc = "GOV.UK environment sync ${title}"

  @@icinga::passive_check { "govuk_env_sync.sh-${title}-${::hostname}":
    ensure              => $general_ensure,
    service_description => $service_desc,
    freshness_threshold => $threshold_secs,
    host_name           => $::fqdn,
    notes_url           => 'https://docs.publishing.service.gov.uk/manual/govuk-env-sync.html',
  }

}
