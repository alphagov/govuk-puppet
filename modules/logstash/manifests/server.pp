class logstash::server {

  anchor { 'logstash::server::begin':
    before => Class['logstash::server::package'],
    notify => Class['logstash::server::service'];
  }

  class { 'logstash::server::package':
    notify => Class['logstash::server::service'];
  }

  class { 'logstash::server::config':
    require   => Class['logstash::server::package'],
    notify    => Class['logstash::server::service'];
  }

  class { 'logstash::server::service':
    before    => Class['logstash::server::monitoring']
  }

  class { 'logstash::server::monitoring': }

  anchor { 'logstash::server::end':
    require => Class['logstash::server::monitoring'],
  }

}
