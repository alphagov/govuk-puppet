# == Custom resource type: govuk_env_sync::s3_sync_task
#
# Creates a configuration file and cron-job, parameterising the govuk_env_sync.sh
# from data provided in hieradata govuk_env_sync::s3_sync_tasks:
#
# [*hour*]
#   The hour when to run the cron job (crontab format, globs ok)
#
# [*minute*]
#   The minute when to run the cron job (crontab format, globs ok)
#
# [*source_bucket*]
#   name of the source bucket without 's3://' prefix e.g. source_bucket
#
# [*destination_bucket*]
#   name of the source bucket without 's3://' prefix, e.g. destination_bucket
#
# [*delete*]
#   Delete objects in destination bucket not in source bucket
#   Default: false
#
# [*ensure*]
#   One of 'present', 'disabled' or 'absent' to control the task.
#   Default: 'present'
#
#
define govuk_env_sync::s3_sync_task(
  $hour,
  $minute,
  $source_bucket,
  $destination_bucket,
  $delete = false,
  $ensure = 'present',
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
    content => template('govuk_env_sync/govuk_env_s3_sync_job.conf.erb'),
  }

  $synccommand = shellquote([
    '/usr/bin/ionice','-c','2','-n','6',
    '/usr/local/bin/with_reboot_lock', "env-sync_${title}",
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
    notes_url           => monitoring_docs_url(data-sync),
  }
}
