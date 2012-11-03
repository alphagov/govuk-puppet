class logstash::server::config (
  $es_heap_size,
  $http_port,
  $transport_port
) {

  include logstash::config

  file { '/var/log/apdex':
    ensure  => 'directory',
    owner   => 'logstash',
    group   => 'logstash',
  }

  if $::govuk_provider == 'sky' {
    $logstash_dir = '/data/logging'
  } else {
    $logstash_dir = '/mnt/logging'
  }

  file { '/etc/logrotate.d/logstash-aggregation':
    ensure => 'file',
    source => 'puppet:///modules/logstash/etc/logrotate.d/logstash-aggregation',
  }

  file { '/etc/logstash/logstash-server.conf':
    content => template('logstash/etc/logstash/logstash-server.conf.erb'),
  }

  file { '/usr/local/bin/apdex.sh':
    source => 'puppet:///modules/logstash/usr/local/bin/apdex.sh',
    mode   => '0755',
  }

  logstash::apdex {
    'www':                   instance_class => 'frontend';
    'calendars':             instance_class => 'frontend';
    'smartanswers':          instance_class => 'frontend';
    'businesssupportfinder': instance_class => 'frontend';
    'search':                instance_class => 'frontend';
    'tariff':                instance_class => 'frontend';
    'publisher':             instance_class => 'backend';
    'imminence':             instance_class => 'backend';
    'panopticon':            instance_class => 'backend';
    'whitehall-frontend':    instance_class => 'whitehall';
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
    command => "/var/apps/logstash/logstash_index_cleaner --port ${http_port} --days-to-keep 4",
    user    => 'logstash',
    minute  => '34',
    hour    => '2',
  }

  elasticsearch::node { 'logstash-server':
    heap_size          => $es_heap_size,
    http_port          => $http_port,
    transport_port     => $transport_port,
    number_of_shards   => '5',
    number_of_replicas => '0',
  }

  if $::govuk_provider == 'sky' {
    file { '/data/logging':
      ensure  => 'directory',
      owner   => 'logstash',
      group   => 'logstash',
      require => File['/data']
    }

    file { '/data/logging/logstash-aggregation':
      ensure  => 'directory',
      owner   => 'logstash',
      group   => 'logstash',
      require => File['/data/logging']
    }

    file { '/var/log/logstash-aggregation':
      ensure  => 'link',
      target  => '/data/logging/logstash-aggregation',
      owner   => 'logstash',
      group   => 'logstash',
      require => File['/data/logging']
    }
  } else {
    file { '/mnt/logging':
      ensure  => 'directory',
      owner   => 'logstash',
      group   => 'logstash'
    }

    file { '/mnt/logging/logstash-aggregation':
      ensure  => 'directory',
      owner   => 'logstash',
      group   => 'logstash',
      require => File['/mnt/logging']
    }

    file { '/var/log/logstash-aggregation':
      ensure  => 'link',
      target  => '/mnt/logging/logstash-aggregation',
      owner   => 'logstash',
      group   => 'logstash',
      require => File['/mnt/logging/logstash-aggregation']
    }
  }
}
