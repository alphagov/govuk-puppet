# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_router_backend inherits govuk::node::s_base {
  include mongodb::server
  include mongodb::backup

  class { 'mongodb::configure_replica_set':
    members => [
      'router-backend-1.router',
      'router-backend-2.router',
      'router-backend-3.router',
    ],
  }

  include govuk::node::s_ruby_app_server

  include govuk::apps::router_api

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  Govuk::Mount['/var/lib/mongodb'] -> Class['mongodb::server']
  Govuk::Mount['/var/lib/automongodbbackup'] -> Class['mongodb::backup']
}
