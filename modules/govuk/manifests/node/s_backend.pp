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

  include govuk::apps::canary_backend
  include govuk::apps::panopticon
  include govuk::apps::publisher
  include govuk::apps::tariff_api
  include govuk::apps::support
  include govuk::apps::contentapi
  include govuk::apps::imminence
  include govuk::apps::signon
  include govuk::apps::search
  include govuk::apps::need_o_tron
  include govuk::apps::migratorator
  class { 'govuk::apps::whitehall':
    configure_admin => true,
    port            => 3026,
    vhost           => 'whitehall-admin',
  }

  # The release App should not go to Skyscape yet
  case $::govuk_provider {
    'sky':   {}
    default: {
      include govuk::apps::release
    }
  }
  # End release App

  class {'govuk::apps::frontend':
    protected => true,
  }

  case $::govuk_provider {
    'sky':   {}
    default: {
      include govuk::apps::review_o_matic_explore
      include govuk::apps::travel_advice_publisher # Only add to EC2 (i.e. preview) for now
    }
  }

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }
}
