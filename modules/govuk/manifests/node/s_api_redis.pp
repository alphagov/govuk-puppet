# == Class govuk::node::s_api_redis
#
# Node class for redis servers in the API vDC.
#
class govuk::node::s_api_redis inherits govuk::node::s_redis_base {
  $redis_port = 6379

  @ufw::allow {
    'allow-redis-from-api':
      from => '10.7.0.0/16',
      port => $redis_port;
  }
}
