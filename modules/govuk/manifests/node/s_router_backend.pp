# == Class: govuk::node::s_router_backend
#
# router backend node
#
class govuk::node::s_router_backend inherits govuk::node::s_base {
  include mongodb::server

  include govuk::node::s_app_server

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  Govuk_mount['/var/lib/mongodb'] -> Class['mongodb::server']
  Govuk_mount['/var/lib/automongodbbackup'] -> Class['mongodb::backup']
  Govuk_mount['/var/lib/s3backup'] -> Class['mongodb::backup']
}
