class govuk_node::frontend_server inherits govuk_node::base {

  include govuk_node::ruby_app_server

  class { 'apache2':
    port => '8080'
  }
  class { 'passenger':
    maxpoolsize => 12
  }

  include govuk::apps::planner
  include govuk::apps::datainsight_frontend
  include govuk::apps::tariff
  include govuk::apps::efg
  include govuk::apps::calendars
  include govuk::apps::smartanswers
  include govuk::apps::feedback
  include govuk::apps::designprinciples
  include govuk::apps::licencefinder
  include govuk::apps::publicapi

  class { 'nginx': node_type => frontend_server }

  # WIP, transitioning frontend to unicorn but don't want changes to go to production yet
  # -- ppotter, 2012-09-03
  case $::govuk_platform {
    production: {
      apache2::vhost::passenger {
        "www.${::govuk_platform}.alphagov.co.uk":
          aliases         => ["frontend.${::govuk_platform}.alphagov.co.uk", 'www.gov.uk'];
        "search.${::govuk_platform}.alphagov.co.uk":
          additional_port => 8083;
        "static.${::govuk_platform}.alphagov.co.uk":;
      }

      nginx::config::vhost::proxy {
        'www.gov.uk':
          to      => ['localhost:8080'];
        "www.$::govuk_platform.alphagov.co.uk":
          to      => ['localhost:8080'],
          aliases => ["frontend.$::govuk_platform.alphagov.co.uk"];
        "search.$::govuk_platform.alphagov.co.uk":
          to => ['localhost:8080'];
        }

      file { "/data/vhost/frontend.${::govuk_platform}.alphagov.co.uk":
        ensure => link,
        target => "/data/vhost/www.${::govuk_platform}.alphagov.co.uk",
        owner  => 'deploy',
        group  => 'deploy',
      }
    }
    default: {
      include govuk::apps::frontend

      apache2::vhost::passenger {
        "search.${::govuk_platform}.alphagov.co.uk":
          additional_port => 8083;
        "static.${::govuk_platform}.alphagov.co.uk":;
      }

      nginx::config::vhost::proxy {
        "search.$::govuk_platform.alphagov.co.uk":
          to => ['localhost:8080'];
      }
    }
  }

  nginx::config::vhost::static { "static.$::govuk_platform.alphagov.co.uk":
    protected => false,
    aliases   => ['calendars', 'planner', 'smartanswers', 'static', 'frontend', 'designprinciples', 'licencefinder', 'tariff', 'efg', 'feedback'],
    ssl_only  => true
  }
}
