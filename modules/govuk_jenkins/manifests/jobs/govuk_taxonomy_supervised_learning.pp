# == Class: govuk_jenkins::jobs::govuk_taxonomy_supervised_learning
#
# Runs the Taxonomy Supervised Learning pipeline
#
#
class govuk_jenkins::jobs::govuk_taxonomy_supervised_learning (
  $app_domain_internal = hiera('app_domain_internal'),
  $app_domain = hiera('app_domain')
) {

  if $::aws_migration {
    $app_domain_to_use = $app_domain_internal
  } else {
    $app_domain_to_use = $app_domain
  }

  $rummager_api = "search.${app_domain_to_use}"
  $draft_content_store_api = "draft-content-store.${app_domain_to_use}"

  file { '/etc/jenkins_jobs/jobs/govuk_taxonomy_supervised_learning.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/govuk_taxonomy_supervised_learning.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
