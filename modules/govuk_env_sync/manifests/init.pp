#
#
#
class govuk_env_sync(
  $tasks = {},
  $user = 'govuk-backup',
  $conf_dir = '/etc/govuk_env_sync',
  $aws_region = 'eu-west-1',
  $db_password = undef,
) {

  include govuk_env_sync::lock_file

  create_resources(govuk_env_sync::task, $tasks, {
    'db_password' => $db_password,
  })
}
