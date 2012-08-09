class logstash::server::config (
  $http_port,
  $transport_port
) {

  include logstash::config


  file { '/etc/logstash/logstash-server.conf' :
    content => template('logstash/etc/logstash/logstash-server.conf.erb'),
  }

  file { '/etc/cron.daily/logstash_index_cleaner' :
    source => 'puppet:///modules/logstash/etc/cron.daily/logstash_index_cleaner',
    mode   => '0755',
  }

  elasticsearch::node { 'logstash-server':
    http_port          => $http_port,
    transport_port     => $transport_port,
    number_of_shards   => '5',
    number_of_replicas => '0',
  }

}
