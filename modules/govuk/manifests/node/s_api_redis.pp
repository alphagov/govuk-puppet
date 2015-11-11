# == Class govuk::node::s_api_redis
#
# Node class for redis servers in the API vDC.
#
# === Parameters
#
# [*allowed_api_ip_range*]
#   Range of API IP addresses that is allowed to access API redis
#
# [*allowed_backend_ip_range*]
#   Range of backend IP addresses that is allowed to access API redis
#
class govuk::node::s_api_redis (
  $allowed_api_ip_range,
  $allowed_backend_ip_range,
) inherits govuk::node::s_redis_base {
  $redis_port = 6379

  @ufw::allow {
    'allow-redis-from-api':
      from => $allowed_api_ip_range,
      port => $redis_port;
  }

  @ufw::allow {
    'allow-redis-from-backend':
      from => $allowed_backend_ip_range,
      port => $redis_port;
  }
}
