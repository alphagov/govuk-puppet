class logstash::server::config {
  include logstash::config

  file { '/etc/logstash/logstash-server.conf' :
    source => 'puppet:///modules/logstash/etc/logstash/logstash-server.conf',
  }

  file { '/etc/cron.daily/logstash_index_cleaner' :
    source => 'puppet:///modules/logstash/etc/cron.daily/logstash_index_cleaner',
    mode   => '0755',
  }

  elasticsearch::node { 'logstash-server':
    http_port          => '9291',
    transport_port     => '9391',
    number_of_shards   => '5',
    number_of_replicas => '0',
  }

}
