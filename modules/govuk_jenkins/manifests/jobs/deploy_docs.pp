# == Class: govuk_jenkins::jobs::deploy_docs
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::deploy_docs (
  $github_token = undef,
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $app_domain = hiera('app_domain'),
) {
  $service_description = 'Deploy the developer docs to S3'

  file { '/etc/jenkins_jobs/jobs/deploy_docs.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_docs.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check {
    "deploy_developer_docs_${::hostname}":
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => 5400, # 90 minutes
      action_url          => "https://deploy.${app_domain}/job/deploy-developer-docs/";
  }
}
