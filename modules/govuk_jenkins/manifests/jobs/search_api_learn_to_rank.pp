# == Class: govuk_jenkins::jobs::search_api_learn_to_rank
#
# This job is used to train and deploy the machine learning model used by the Search API to improve search relevance.
#
#
# === Parameters
#
# [*aws_role_arn*]
#   AWS Role ARN to assume for model training and deployment
#
# [*elasticsearch_uri*]
#   URI of Elasticsearch cluster for generating training data
#
# [*image*]
#   The image name to use in SageMaker for training the model
#
# [*train_instance_type*]
#   The type of instance used by AWS SageMaker to train the model
#
# [*train_instance_count*]
#   The number instances used by AWS SageMaker to train the model
#
# [*deploy_instance_type*]
#   The type of instance used by AWS SageMaker to host the deployed model
#
# [*deploy_instance_count*]
#   The number instances used by AWS SageMaker to host the deployed model
#
# [*bigquery_credentials*]
#   Credentials for Google BigQuery to generate training data
#
# [*ssh_private_key*]
#   The SSH private key for access to the EC2 instances in the LTR ASG
#
class govuk_jenkins::jobs::search_api_learn_to_rank (
  $aws_role_arn = undef,
  $elasticsearch_uri = undef,
  $image = undef,
  $train_instance_type = undef,
  $train_instance_count = undef,
  $deploy_instance_type = undef,
  $deploy_instance_count = undef,
  $bigquery_credentials = undef,
  $ssh_private_key = undef,
) {

  $service_description = 'Train and deploy LTR model for Search API'
  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')

  file { '/etc/jenkins_jobs/jobs/search_api_learn_to_rank.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/search_api_learn_to_rank.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'];
  }

  @@icinga::passive_check { "search_api_learn_to_rank_${::hostname}":
      ensure              => present,
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => 86400,
      action_url          => "https://${deploy_jenkins_domain}/job/search-api-learn-to-rank/",
      notes_url           => monitoring_docs_url(search-api-learn-to-rank),
  }
}
