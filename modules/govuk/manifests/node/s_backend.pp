class govuk::node::s_backend inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server
  include java::oracle7::jdk
  include java::oracle7::jre

  class { 'java::set_defaults':
    jdk => 'oracle7',
    jre => 'oracle7',
  }

  package { 'graphviz':
    ensure => installed
  }

  include imagemagick

  $app_domain = extlookup('app_domain')

  file { "/data/vhost/signonotron.${app_domain}":
    ensure => absent,
    force  => true,
  }

  include govuk::apps::asset_manager
  include govuk::apps::canary_backend
  include govuk::apps::fact_cave
  include govuk::apps::govuk_delivery
  include govuk::apps::imminence
  include govuk::apps::kibana
  include govuk::apps::need_o_tron
  include govuk::apps::panopticon
  include govuk::apps::publisher
  include govuk::apps::release
  include govuk::apps::search
  include govuk::apps::signon
  include govuk::apps::support

  if str2bool(extlookup('govuk_enable_need_api', 'no')) {
    include govuk::apps::need_api
  }

  if str2bool(extlookup('govuk_enable_maslow', 'no')) {
    include govuk::apps::maslow
  }

  if str2bool(extlookup('govuk_enable_tariff_admin', 'no')) {
    include govuk::apps::tariff_admin
  }
  if str2bool(extlookup('govuk_enable_contacts', 'no')) {
    include govuk::apps::contacts
  }

  include govuk::apps::tariff_api
  include govuk::apps::transition
  include govuk::apps::travel_advice_publisher

  class { 'govuk::apps::contentapi': vhost_protected => false }
  class { 'govuk::apps::frontend':   vhost_protected => true  }
  class { 'govuk::apps::whitehall':
    configure_admin => true,
    port            => 3026,
    vhost_protected => true,
    vhost           => 'whitehall-admin',
  }

  # Remove all trace of apache
  include apache::remove
  # And use nginx instead
  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  # Local proxy for Rummager to access ES cluster.
  class { 'elasticsearch::local_proxy':
    servers => [
      'elasticsearch-1.backend',
      'elasticsearch-2.backend',
      'elasticsearch-3.backend',
    ],
  }
}
