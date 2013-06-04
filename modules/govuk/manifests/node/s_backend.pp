class govuk::node::s_backend inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server
  include rbenv

  rbenv::version { '1.9.3-p392':
    bundler_version => '1.3.5'
  }
  rbenv::alias { '1.9.3':
    to_version => '1.9.3-p392',
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
  include govuk::apps::tariff_admin
  include govuk::apps::tariff_api
  include govuk::apps::transition
  include govuk::apps::travel_advice_publisher

  if str2bool(extlookup('govuk_enable_tariff_demo', 'no')) {
    include govuk::apps::tariff_demo_api
  }
  if str2bool(extlookup('govuk_enable_fact_cave', 'no')) {
    include govuk::apps::fact_cave
  }

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
