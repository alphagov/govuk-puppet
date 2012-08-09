class logstash::server {

  $http_port      = '9291'
  $transport_port = '9391'

  anchor { 'logstash::server::begin':
    before => Class['logstash::server::package'],
    notify => Class['logstash::server::service'];
  }

  class { 'logstash::server::package':
    notify => Class['logstash::server::service'];
  }

  class { 'logstash::server::config':
    http_port      => $http_port,
    transport_port => $transport_port,
    require        => Class['logstash::server::package'],
    notify         => Class['logstash::server::service'];
  }

  class { 'logstash::server::service':
    http_port      => $http_port,
    transport_port => $transport_port,
  }

  anchor { 'logstash::server::end':
    require => Class['logstash::server::service'],
  }

}
