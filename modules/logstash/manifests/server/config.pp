class logstash::server::config (
  $http_port,
  $transport_port
) {

  include logstash::config

  file { '/var/log/logstash-aggregation':
    ensure  => 'directory',
    owner   => 'logstash',
    group   => 'logstash',
  }

  file { '/var/log/apdex':
    ensure  => 'directory',
    owner   => 'logstash',
    group   => 'logstash',
  }

  @logrotate::conf { 'logstash-aggregation':
    matches      => '/var/log/logstash-aggregation/**/*',
    days_to_keep => '365',
  }

  file { '/etc/logstash/logstash-server.conf':
    content => template('logstash/etc/logstash/logstash-server.conf.erb'),
  }

  file { '/usr/local/bin/apdex.sh':
    source => 'puppet:///modules/logstash/usr/local/bin/apdex.sh',
    mode   => '0755',
  }

  cron { 'apdex-for-frontend':
    command => "/usr/local/bin/apdex.sh frontend www",
    user    => 'logstash',
    minute  => '30',
  }

  package { 'ordereddict':
    ensure   => 'present',
    provider => 'pip',
  }

  file { '/var/apps/logstash/logstash_index_cleaner':
    source => 'puppet:///modules/logstash/etc/cron.daily/logstash_index_cleaner',
    mode   => '0755',
  }

  cron { 'logstash-clean-indices':
    command => "/var/apps/logstash/logstash_index_cleaner --port ${http_port} --days-to-keep 7",
    user    => 'logstash',
    minute  => '34',
    hour    => '2',
  }

  elasticsearch::node { 'logstash-server':
    http_port          => $http_port,
    transport_port     => $transport_port,
    number_of_shards   => '5',
    number_of_replicas => '0',
  }

}
