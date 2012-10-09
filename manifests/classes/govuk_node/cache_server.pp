class govuk_node::cache_server inherits govuk_node::base {

  include govuk::htpasswd
  include jetty
  include mirror
  include nginx
  include router
  include router::nginx

  class { 'varnish':
    storage_size => '6G',
    default_ttl  => '900',
  }
  nginx::config::vhost::default { 'default':
    status => '444',
  }
}
