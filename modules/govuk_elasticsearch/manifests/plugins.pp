# == Class govuk_elasticsearch::plugins
#
# Install plugins on an Elasticsearch node
#
class govuk_elasticsearch::plugins (
  $elasticsearch_version = $::govuk_elasticsearch::version,
  $elasticsearch_configdir = $::elasticsearch::configdir,
){

  elasticsearch::plugin { 'discovery-ec2':
    ensure     => 'present',
    module_dir => 'discovery-ec2',
    instances  => $::fqdn,
    configdir  => $elasticsearch_configdir,
  }

  elasticsearch::plugin { 'repository-s3':
    ensure     => 'present',
    module_dir => 'repository-s3',
    instances  => $::fqdn,
    configdir  => $elasticsearch_configdir,
  }
}
