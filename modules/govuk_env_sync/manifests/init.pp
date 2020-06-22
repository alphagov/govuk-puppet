#
#
#
class govuk_env_sync(
  $tasks = {},
  $s3_sync_tasks = {},
  $user = 'govuk-backup',
  $conf_dir = '/etc/govuk_env_sync',
  $aws_region = 'eu-west-1',
  $document_db_credentials = undef,
) {

  include govuk_env_sync::lock_file

  ensure_packages(['jq'])

  file { $conf_dir:
    ensure  => 'directory',
    recurse => true,
    purge   => true,
    force   => true,
    owner   => $user,
    group   => $user,
    mode    => '0770',
  }

  create_resources(govuk_env_sync::task, $tasks)
  create_resources(govuk_env_sync::s3_sync_task, $s3_sync_tasks)

  if $document_db_credentials {
    create_resources(govuk_env_sync::documentdb_auth, $document_db_credentials)
  }
}
