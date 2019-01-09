#
#
#
class govuk_env_sync(
  $tasks = {},
  $user = 'govuk-backup',
  $conf_dir = '/etc/govuk_env_sync',
  $aws_region = 'eu-west-1',
) {

  include govuk_env_sync::lock_file

  file_line { 'sudo_rule_command':
    path => '/etc/sudoers',
    line => 'Cmnd_Alias BACKUP=/usr/local/bin/govuk_env_sync.sh',
  }

  file_line { 'sudo_rule_govuk_backup':
    path => '/etc/sudoers',
    line => 'deploy ALL=(govuk-backup) NOPASSWD:BACKUP',
  }

  create_resources(govuk_env_sync::task, $tasks)
}
