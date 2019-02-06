# == Class govuk_elasticsearch::plugins
#
# Install plugins on an Elasticsearch node
#
class govuk_elasticsearch::plugins (
  $elasticsearch_version = $::govuk_elasticsearch::version,
  $elasticsearch_configdir = $::elasticsearch::configdir,
){

  if versioncmp($elasticsearch_version, '2.4.6') == 0 {
    $ensure_cloud_aws = 'present'
    $ensure_mobz_head = 'present'
    $ensure_discovery_ec2 = 'absent'
    $ensure_repository_s3 = 'absent'
  }
  # If the version is 5.0 or newer, then install the two plugins it got split into:
  # https://www.elastic.co/guide/en/elasticsearch/plugins/5.0/cloud-aws.html
  elsif versioncmp($elasticsearch_version, '5.0') >= 0 {
    $ensure_cloud_aws = 'absent'
    $ensure_mobz_head = 'absent'
    $ensure_discovery_ec2 = 'present'
    $ensure_repository_s3 = 'present'
  }

  elasticsearch::plugin { 'cloud-aws':
    ensure     => $ensure_cloud_aws,
    module_dir => 'cloud-aws',
    instances  => $::fqdn,
    configdir  => $elasticsearch_configdir,
  }

  elasticsearch::plugin { 'mobz/elasticsearch-head':
    ensure     => $ensure_mobz_head,
    module_dir => 'head',
    instances  => $::fqdn,
    configdir  => $elasticsearch_configdir,
  }

  elasticsearch::plugin { 'discovery-ec2':
    ensure     => $ensure_discovery_ec2,
    module_dir => 'discovery-ec2',
    instances  => $::fqdn,
    configdir  => $elasticsearch_configdir,
  }

  elasticsearch::plugin { 'repository-s3':
    ensure     => $ensure_repository_s3,
    module_dir => 'repository-s3',
    instances  => $::fqdn,
    configdir  => $elasticsearch_configdir,
  }
}
