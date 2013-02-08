class collectd::plugin::elasticsearch(
  $es_port,
  $es_cluster
) {
  include collectd::plugin::python

  # Attribution: https://github.com/phobos182/collectd-elasticsearch
  @file { '/usr/lib/collectd/python/elasticsearch.py':
    ensure  => present,
    source  => 'puppet:///modules/collectd/usr/lib/collectd/python/elasticsearch.py',
    tag     => 'collectd::plugin',
    notify  => File['/etc/collectd/conf.d/elasticsearch.conf'],
  }

  @file { '/usr/lib/collectd/python/elasticsearch.pyc':
    ensure  => undef,
    tag     => 'collectd::plugin',
  }

  @collectd::plugin { 'elasticsearch':
    content => template('collectd/etc/collectd/conf.d/elasticsearch.conf.erb'),
    require => Class['collectd::plugin::python'],
  }
}
