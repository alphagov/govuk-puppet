class elasticsearch::config($cluster) {
  file {'/etc/elasticsearch/elasticsearch.yml':
    content => template('elasticsearch/elasticsearch.yml.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Class['elasticsearch::package'],
    notify  => Class['elasticsearch::service']
  }

  file {'/etc/default/elasticsearch':
    source  => 'puppet:///modules/elasticsearch/etc/default/elasticsearch',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Class['elasticsearch::package'],
    notify  => Class['elasticsearch::service']
  }
}
