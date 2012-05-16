# elasticsearch::config
# manages elasticsearch's configfiles
class elasticsearch::config($cluster) {
  file {'/etc/elasticsearch/elasticsearch.yml':
    source  => 'puppet:///modules/elasticsearch/etc/elasticsearch/elasticsearch.yml',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Class['elasticsearch::install'],
    notify  => Class['elasticsearch::service']
  }

  file {'/etc/default/elasticsearch':
    content => template("elasticsearch/elasticsearch.yml.erb"),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Class['elasticsearch::install'],
    notify  => Class['elasticsearch::service']
  }
}
