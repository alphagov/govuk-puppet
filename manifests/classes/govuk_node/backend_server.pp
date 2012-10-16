class govuk_node::backend_server inherits govuk_node::base {
  include govuk_node::ruby_app_server

  class { 'apache2':
    port => '8080',
  }
  class { 'passenger':
    maxpoolsize => 12,
  }

  package { 'graphviz':
    ensure => installed
  }

  include imagemagick

  apache2::vhost::passenger {
    "migratorator.${::govuk_platform}.alphagov.co.uk":;
  }

  nginx::config::vhost::proxy {
    "migratorator.$::govuk_platform.alphagov.co.uk":
      to        => ['localhost:8080'],
      ssl_only  => true;
  }

  file { "/data/vhost/signonotron.${::govuk_platform}.alphagov.co.uk":
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
  include govuk::apps::private_frontend
  include govuk::apps::search
  include govuk::apps::need_o_tron

  case $::govuk_provider {
    'scc':   {}
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
