# == Class: govuk::node::s_development
#
# GOV.UK development VM.
#
class govuk::node::s_development {
  include base
  include resolvconf

  include assets::user
  include golang
  include govuk_apt::disable_pipelining
  include govuk_mysql::libdev
  include hosts::development
  include imagemagick
  include memcached
  include mongodb::server
  include mysql::client
  include nodejs
  include puppet
  include govuk_rabbitmq
  include redis
  include tmpreaper
  include users

  include govuk::deploy
  include govuk::envsys
  include govuk::python
  include govuk::testing_tools
  include govuk::sshkeys

  include govuk_rbenv::all

  include router::assets_origin

  include govuk::apps::bouncer
  include govuk::apps::businesssupportfinder
  include govuk::apps::calculators
  include govuk::apps::calendars
  include govuk::apps::collections
  include govuk::apps::contacts_frontend
  include govuk::apps::contentapi
  include govuk::apps::courts_api
  include govuk::apps::courts_frontend
  include govuk::apps::designprinciples
  include govuk::apps::feedback
  include govuk::apps::finder_frontend
  include govuk::apps::frontend
  include govuk::apps::government_frontend
  include govuk::apps::info_frontend
  include govuk::apps::licencefinder
  include govuk::apps::manuals_frontend
  include govuk::apps::smartanswers
  include govuk::apps::specialist_frontend
  include govuk::apps::tariff

  include govuk::apps::asset_manager
  include govuk::apps::authenticating_proxy
  include govuk::apps::backdrop_read
  include govuk::apps::backdrop_write
  include govuk::apps::backdrop_write::rabbitmq
  include govuk::apps::business_support_api
  include govuk::apps::canary_backend
  include govuk::apps::canary_frontend
  include govuk::apps::collections_publisher
  include govuk::apps::contacts
  include govuk::apps::content_register
  include govuk::apps::content_register::rabbitmq
  include govuk::apps::content_store
  include govuk::apps::content_store::enable_running_in_draft_mode
  include govuk::apps::efg
  include govuk::apps::email_alert_api
  include govuk::apps::email_alert_frontend
  include govuk::apps::email_alert_monitor
  include govuk::apps::email_alert_service
  include govuk::apps::email_alert_service::rabbitmq_permissions
  include govuk::apps::email_alert_service::rabbitmq_test_permissions
  include govuk::apps::email_campaign_frontend
  include govuk::apps::email_campaign_api
  include govuk::apps::errbit
  include govuk::apps::event_store
  include govuk::apps::govuk_delivery
  include govuk::apps::hmrc_manuals_api
  include govuk::apps::imminence
  include govuk::apps::kibana
  include govuk::apps::maslow
  include govuk::apps::metadata_api
  include govuk::apps::need_api
  include govuk::apps::panopticon
  include govuk::apps::panopticon::rabbitmq
  include govuk::apps::performanceplatform_admin
  include govuk::apps::policy_publisher
  include govuk::apps::publicapi
  include govuk::apps::public_event_store
  include govuk::apps::publisher
  include govuk::apps::publishing_api
  include govuk::apps::publishing_api::rabbitmq
  include govuk::apps::release
  include govuk::apps::router
  include govuk::apps::router_api
  include govuk::apps::rummager
  include govuk::apps::search_admin
  include govuk::apps::service_manual_publisher
  include govuk::apps::short_url_manager
  include govuk::apps::signon
  include govuk::apps::specialist_publisher
  include govuk::apps::stagecraft
  include govuk::apps::stagecraft::rabbitmq
  include govuk::apps::static
  include govuk::apps::support
  include govuk::apps::support_api
  include govuk::apps::tariff_admin
  include govuk::apps::tariff_api
  include govuk::apps::transition
  include govuk::apps::travel_advice_publisher
  include govuk::apps::url_arbiter
  include govuk::apps::whitehall

  include govuk_java::openjdk7::jdk
  include govuk_java::openjdk7::jre
  class { 'govuk_java::set_defaults':
    jdk => 'openjdk7',
    jre => 'openjdk7',
  }

  class { 'govuk_elasticsearch':
    cluster_name       => 'govuk-development',
    heap_size          => '256m',
    number_of_shards   => '1',
    number_of_replicas => '0',
    require            => Class['govuk_java::set_defaults'],
  }

  elasticsearch::plugin { 'mobz/elasticsearch-head':
    module_dir => 'head',
    instances  => $::fqdn,
  }

  include nginx

  nginx::config::vhost::default { 'default': }
  nginx::config::site { 'development':
    source => 'puppet:///modules/nginx/development',
  }

  # No `root_password` means that none will be set.
  # Rather than a hash of an hash empty string.
  class { 'govuk_mysql::server': }

  mysql::db {
    ['collections_publisher_development', 'collections_publisher_test']:
      user     => 'collections_pub',
      password => 'collections_publisher';

    ['contacts_development', 'contacts_test']:
      user     => 'contacts',
      password => 'contacts';

    [
      'efg_development',
      'efg_test',
      'efg_test1',
      'efg_test2',
      'efg_test3',
      'efg_test4',
      'efg_il0',
    ]:
      user     => 'efg',
      password => 'efg';

    ['release_development', 'release_test']:
      user     => 'release',
      password => 'release';

    ['search_admin_development', 'search_admin_test']:
      user     => 'search_admin',
      password => 'search_admin';

    [
      'signonotron2_development',
      'signonotron2_test',
      'signonotron2_integration_test',
    ]:
      user     => 'signonotron2',
      password => 'signonotron2';

    ['tariff_admin_development', 'tariff_admin_test']:
      user     => 'tariff_admin',
      password => 'tariff_admin';

    ['tariff_development', 'tariff_test']:
      user     => 'tariff',
      password => 'tariff';

    [
      'whitehall_development',
      'whitehall_test',
      'whitehall_test1',
      'whitehall_test2',
      'whitehall_test3',
      'whitehall_test4',
    ]:
      user     => 'whitehall',
      password => 'whitehall';
  }

  include govuk_postgresql::server::standalone
  include govuk_postgresql::client
  include postgresql::server::contrib

  # Create the vagrant user role with permission to create databases.
  #
  # Note: we do not explicitly create the development/test versions of the
  # databases via puppet, it is expected that databases will be created in
  # development using the `rake db:create` command.
  postgresql::server::role {
    'vagrant':
      password_hash => postgresql_password('vagrant', 'vagrant'),
      createdb      => true;
  }

  package {
    'sqlite3':        ensure => 'installed'; # gds-sso uses sqlite3 to run its test suite
    'wbritish-small': ensure => installed;
    'vegeta':         ensure => installed; # vegeta is used by the router test suite
    'mawk-1.3.4':     ensure => installed; # Provides /opt/mawk required by pre-transition-stats
  }
}
