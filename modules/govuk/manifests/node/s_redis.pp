class govuk::node::s_redis inherits govuk::node::s_redis_base {
  $redis_port = 6379

  @ufw::allow {
    'allow-redis-from-backend':
      from => '10.3.0.0/16',
      port => $redis_port;
    'allow-redis-from-frontend':
      from => '10.2.0.0/16',
      port => $redis_port;
    'allow-redis-from-management':
      from => '10.0.0.0/16',
      port => $redis_port;
    'allow-redis-from-router':
      from => '10.1.0.0/16',
      port => $redis_port;
    'allow-redis-from-efg':
      from => '10.4.0.0/16',
      port => $redis_port;
    'allow-redis-from-licensify':
      from => '10.5.0.0/16',
      port => $redis_port;
    'allow-redis-from-redirector':
      from => '10.6.0.0/16',
      port => $redis_port;
  }
}
