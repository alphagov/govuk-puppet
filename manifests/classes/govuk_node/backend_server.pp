class govuk_node::backend_server inherits govuk_node::base {
  include govuk_node::ruby_app_server

  package { 'graphviz':
    ensure => installed
  }

  include imagemagick

  $app_domain = extlookup('app_domain')

  file { "/data/vhost/signonotron.${app_domain}":
    ensure => absent,
    force  => true,
  }

  include govuk::apps::panopticon
  include govuk::apps::publisher
  include govuk::apps::tariff_api
  include govuk::apps::whitehall_admin
  include govuk::apps::support
  include govuk::apps::contentapi
  include govuk::apps::imminence
  include govuk::apps::signon
  include govuk::apps::frontend
  include govuk::apps::search
  include govuk::apps::need_o_tron
  include govuk::apps::migratorator

  case $::govuk_provider {
    'sky':   {}
    default: {
      include govuk::apps::review_o_matic_explore
    }
  }

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default':
    status => '500',
  }
}
