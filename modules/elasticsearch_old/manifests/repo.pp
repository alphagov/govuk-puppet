# == Class: elasticsearch_old::repo
#
# Pretending to be:
# https://github.com/elasticsearch/puppet-elasticsearch/blob/master/manifests/repo.pp
#
class elasticsearch_old::repo {
  apt::source { 'elasticsearch-0.90':
    location => 'http://packages.elasticsearch.org/elasticsearch/0.90/debian',
    release  => 'stable',
    key      => 'D88E42B4',
  }
}
