# == Class: govuk::apps::public_event_store
#
# Public event store is a simple proxy from the frontend machines to the
# event_store application on the backend machines.
#
class govuk::apps::public_event_store {

  $app_domain = hiera('app_domain')

  $internal_domain = "event-store.${app_domain}"
  $public_domain = "public-event-store.${app_domain}"

  nginx::config::vhost::proxy { $public_domain:
    ensure    => 'absent',
    to        => [$internal_domain],
    to_ssl    => true,
    protected => false,
    ssl_only  => false,
  }
}
