class govuk_node::backend_server inherits govuk_node::base {
  include govuk_node::ruby_app_server

  class { 'apache2':
    port => '8080',
  }
  class { 'passenger':
    maxpoolsize => 12,
  }

  class { 'nginx':
    node_type => backend_server,
  }
  package { 'graphviz':
    ensure => installed
  }

  include imagemagick

  # WIP, transitioning frontend to unicorn but don't want changes to go to production yet
  # -- ppotter, 2012-09-03
  case $::govuk_platform {
    production: {
      apache2::vhost::passenger {
        "panopticon.${::govuk_platform}.alphagov.co.uk":;
      }

      nginx::config::vhost::proxy {
        "panopticon.$::govuk_platform.alphagov.co.uk":
          to       => ['localhost:8080'],
          ssl_only => true;
      }
    }
    default: {
      include govuk::apps::panopticon
    }
  }
  apache2::vhost::passenger {
    "needotron.${::govuk_platform}.alphagov.co.uk":;
    "signon.${::govuk_platform}.alphagov.co.uk":;
    "publisher.${::govuk_platform}.alphagov.co.uk":;
    "imminence.${::govuk_platform}.alphagov.co.uk":;
    "contactotron.${::govuk_platform}.alphagov.co.uk":;
    "migratorator.${::govuk_platform}.alphagov.co.uk":;
    "reviewomatic.${::govuk_platform}.alphagov.co.uk":;
    "private-frontend.${::govuk_platform}.alphagov.co.uk":;
  }

  nginx::config::vhost::proxy {
    "imminence.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "publisher.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "needotron.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "signon.$::govuk_platform.alphagov.co.uk":
      to        => ['localhost:8080'],
      protected => false,
      ssl_only  => true;
    "migratorator.$::govuk_platform.alphagov.co.uk":
      to        => ['localhost:8080'],
      ssl_only  => true;
    "reviewomatic.$::govuk_platform.alphagov.co.uk":
      to        => ['localhost:8080'],
      ssl_only  => false;
    "contactotron.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "private-frontend.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
  }

  file { "/data/vhost/signonotron.${::govuk_platform}.alphagov.co.uk":
    ensure => absent,
    force  => true,
  }

  include govuk::apps::review_o_matic_explore
  include govuk::apps::tariff_api
  include govuk::apps::whitehall_admin
  include govuk::apps::support
  include govuk::apps::contentapi
}
