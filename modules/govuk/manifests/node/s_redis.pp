# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_redis inherits govuk::node::s_redis_base {
  $redis_port = 6379

  @ufw::allow {
    'allow-redis-from-anywhere':
      from => 'any',
      port => $redis_port;
  }
}
