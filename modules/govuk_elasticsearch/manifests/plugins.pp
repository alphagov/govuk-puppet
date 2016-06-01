# == Class govuk_elasticsearch::plugins
#
# Install plugins on an Elasticsearch node
#
class govuk_elasticsearch::plugins {

  elasticsearch::plugin { 'mobz/elasticsearch-head':
    module_dir => 'head',
    instances  => $::fqdn,
  }

}
