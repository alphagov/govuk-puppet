class logstash::server::config {
  include logstash::config
  file { '/etc/logstash/logstash-server.conf' :
    source  => 'puppet:///modules/logstash/etc/logstash/logstash-server.conf',
    require => File['/etc/logstash']
  }
  file { '/etc/cron.daily/logstash_index_cleaner' :
    source  => 'puppet:///modules/logstash/etc/cron.daily/logstash_index_cleaner',
    mode    => '0755'
  }
  file { '/var/apps/elasticsearch-0.18.7/bin/elasticsearch.in.sh' :
    source  => 'puppet:///modules/logstash/elasticsearch.in.sh',
    mode    => '0755',
    require => File['untar-elasticsearch'],
    notify  => Service['elasticsearch-0-18-7'],
  }
  file { '/var/apps/elasticsearch-0.18.7/config/elasticsearch.yml' :
    source  => 'puppet:///modules/logstash/elasticsearch.yml',
    mode    => '0644',
    require => File['untar-elasticsearch'],
    notify  => Service['elasticsearch-0-18-7'],
  }
}
