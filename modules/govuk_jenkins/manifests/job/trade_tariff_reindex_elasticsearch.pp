# == Class: govuk_jenkins::job::trade_tariff_reindex_elasticsearch
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::trade_tariff_reindex_elasticsearch {
  file { '/etc/jenkins_jobs/jobs/trade_tariff_reindex_elasticsearch.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/trade_tariff_reindex_elasticsearch.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
