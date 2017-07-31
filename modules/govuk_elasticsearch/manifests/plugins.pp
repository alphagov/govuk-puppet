# == Class govuk_elasticsearch::plugins
#
# Install plugins on an Elasticsearch node
#
class govuk_elasticsearch::plugins (
  $elasticsearch_version = $::govuk_elasticsearch::version,
){

  elasticsearch::plugin { 'mobz/elasticsearch-head':
    module_dir => 'head',
    instances  => $::fqdn,
  }

  elasticsearch::plugin { 'elasticsearch-migration':
    module_dir => 'migration',
    url        => 'https://github.com/elastic/elasticsearch-migration/releases/download/v1.19/elasticsearch-migration-1.19.zip',
    instances  => $::fqdn,
  }

  if versioncmp($elasticsearch_version, '2.0') < 0 {
    # If version is older than 2.0.0, then install an older plugin
    case $elasticsearch_version {
      /^1.4/:  { $cloud_aws_version = '2.4.2' }
      /^1.5/:  { $cloud_aws_version = '2.5.1' }
      /^1.7/:  { $cloud_aws_version = '2.7.1' }
      default: { fail('Not able to select a version for cloud-aws, see https://github.com/elastic/elasticsearch-cloud-aws') }
    }

    elasticsearch::plugin { "elasticsearch/elasticsearch-cloud-aws/${cloud_aws_version}":
      module_dir => 'cloud-aws',
      instances  => $::fqdn,
    }
  }
  # If the version is 2.4, then install the plugin the 2.4 way
  elsif versioncmp($elasticsearch_version, '2.4') == 0 {
    elasticsearch::plugin { 'cloud-aws':
      module_dir => 'cloud-aws',
      instances  => $::fqdn,
    }
  }
  # If the version is 5.0 or newer, then install the two plugins it got split into:
  # https://www.elastic.co/guide/en/elasticsearch/plugins/5.0/cloud-aws.html
  elsif versioncmp($elasticsearch_version, '5.0') >= 0 {
    elasticsearch::plugin { 'discovery-ec2':
      module_dir => 'discovery-ec2',
      instances  => $::fqdn,
    }

    elasticsearch::plugin { 'repository-s3':
      module_dir => 'repository-s3',
      instances  => $::fqdn,
    }
  }
}
