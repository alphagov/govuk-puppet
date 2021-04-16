# == Class: govuk_jenkins::jobs::govuk_taxonomy_supervised_learning
#
# Runs the Taxonomy Supervised Learning pipeline
#
#
class govuk_jenkins::jobs::govuk_taxonomy_supervised_learning (
  $app_domain_internal = hiera('app_domain_internal'),
  $app_domain = hiera('app_domain')
) {

  $app_domain_to_use = $app_domain_internal
  $rummager_api = "search.${app_domain_to_use}"
  $content_store_api = "content-store.${app_domain_to_use}"

  file { '/etc/jenkins_jobs/jobs/govuk_taxonomy_supervised_learning.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/govuk_taxonomy_supervised_learning.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
