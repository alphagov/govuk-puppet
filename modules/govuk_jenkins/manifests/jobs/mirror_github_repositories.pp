# == Class: govuk_jenkins::jobs::mirror_github_repositories
#
# Manages the process of backing up our GitHub code repositories to AWS CodeCommit.
#
# === Parameters:
#
# [* aws_codecommit_user_id *]
#   IAM user with privileges to assume the role in aws_role_arn
#
# [* aws_role_arn *]
#   IAM role with privileges to create, list and push to CodeCommit repositories
#
# [*cron_schedule *]
#   The cron schedule to specify how often this task will run
#   Default: undef
#
# [* mirror_repos_github_api_token *]
#   A personal access token with `read:org` and `repo` scope
#
# [* ssh_private_key *]
#   A private key attached to the IAM user in aws_codecommit_user_id
#
class govuk_jenkins::jobs::mirror_github_repositories (
  $codecommit_user_id = undef,
  $role_arn = undef,
  $cron_schedule = undef,
  $enable_slack_notifications = false,
  $environment_variables = $govuk_jenkins::environment_variables,
  $mirror_repo_github_api_token = undef,
  $github_ssh_private_key = undef,
) {

  $slack_team_domain = 'govuk'
  $slack_room = '2ndline'
  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')
  $slack_build_server_url = "https://${deploy_jenkins_domain}/"

  file { '/etc/jenkins_jobs/jobs/mirror_github_repositories.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/mirror_github_repositories.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
