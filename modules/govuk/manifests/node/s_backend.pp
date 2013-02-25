class govuk::node::s_backend inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server

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
  include govuk::apps::imminence
  include govuk::apps::migratorator
  include govuk::apps::need_o_tron
  include govuk::apps::panopticon
  include govuk::apps::publisher
  include govuk::apps::release
  include govuk::apps::search
  include govuk::apps::signon
  include govuk::apps::support
  include govuk::apps::tariff_api
  include govuk::apps::travel_advice_publisher

  class { 'govuk::apps::contentapi': vhost_protected => false }
  class { 'govuk::apps::frontend':   vhost_protected => true  }
  class { 'govuk::apps::whitehall':
    configure_admin => true,
    port            => 3026,
    vhost_protected => true,
    vhost           => 'whitehall-admin',
  }

  if str2bool(extlookup('govuk_enable_kibana', 'no')) {
    include govuk::apps::kibana
  }

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }
}
