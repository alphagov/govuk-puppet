class logstash::client {

  anchor { 'logstash::client::begin':
    before => Class['logstash::client::package'],
    notify => Class['logstash::client::service'];
  }

  class { 'logstash::client::package':
    notify => Class['logstash::client::service'];
  }

  class { 'logstash::client::config':
    require   => Class['logstash::client::package'],
    notify    => Class['logstash::client::service'];
  }

  class { 'logstash::client::service': }

  anchor { 'logstash::client::end':
    require => Class['logstash::client::service'],
  }

  # Realize all defined collectors and grok patterns
  Logstash::Collector <| |>
  Logstash::Pattern <| |>

}
