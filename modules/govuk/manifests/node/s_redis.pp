class govuk::node::s_redis {

  $redis_port = 6379

  include govuk::node::s_base

  class { 'redis':
    redis_max_memory => '1gb',
    redis_port       => $redis_port,
  }

  @ufw::allow {
    'allow-redis-from-backend':
      from => '10.3.0.0/16',
      port => $redis_port,
    'allow-redis-from-frontend':
      from => '10.2.0.0/16',
      port => $redis_port,
  }

}
