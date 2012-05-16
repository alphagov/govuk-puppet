# elasticsearch::config
# manages elasticsearch's configfiles
class elasticsearch::config {
  file {'/etc/elasticsearch/elasticsearch.yml':
    source  => 'puppet:///modules/elasticsearch/etc/elasticsearch/elasticsearch.yml',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Class['elasticsearch::install'],
    notify  => Class['elasticsearch::service']
  }

  file {'/etc/default/elasticsearch':
    source  => 'puppet:///modules/elasticsearch/etc/default/elasticsearch',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Class['elasticsearch::install'],
    notify  => Class['elasticsearch::service']
  }
}
