# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_development {
  include base

  include assets::user
  include fonts
  include golang
  include govuk_apt::disable_pipelining
  include govuk_apt::use_uk_ubuntu_mirror
  include govuk_mysql::libdev
  include hosts::development
  include imagemagick
  include mongodb::server
  include mysql::client
  include nodejs
  include puppet
  include govuk_rabbitmq
  include redis
  include tmpreaper
  include users

  class { 'memcached':
    max_memory => 64,
    listen_ip  => '127.0.0.1',
  }

  include govuk::deploy
  include govuk::envsys
  include govuk::python
  include govuk::repository
  include govuk::testing_tools
  include govuk::sshkeys
  include govuk::sshkeys::from_hiera

  include rbenv
  rbenv::version { '1.9.3-p392':
    bundler_version => '1.6.5'
  }
  rbenv::version { '1.9.3-p484':
    bundler_version => '1.6.5'
  }
  rbenv::version { '1.9.3-p545':
    bundler_version => '1.6.5'
  }
  rbenv::alias { '1.9.3':
    to_version => '1.9.3-p545',
  }

  rbenv::version { '2.0.0-p247':
    bundler_version => '1.6.5'
  }
  rbenv::version { '2.0.0-p353':
    bundler_version => '1.6.5'
  }
  rbenv::version { '2.0.0-p451':
    bundler_version => '1.6.5'
  }
  rbenv::alias { '2.0.0':
    to_version => '2.0.0-p451',
  }

  rbenv::version { '2.1.2':
    bundler_version => '1.6.5'
  }
  rbenv::alias { '2.1':
    to_version => '2.1.2'
  }

  include router::assets_origin

  class {
    'govuk::apps::bouncer':               vhost_protected => false;
    'govuk::apps::businesssupportfinder': vhost_protected => false;
    'govuk::apps::calculators':           vhost_protected => false;
    'govuk::apps::calendars':             vhost_protected => false;
    'govuk::apps::collections':           vhost_protected => false;
    'govuk::apps::contacts_frontend':     vhost_protected => false;
    'govuk::apps::contentapi':            vhost_protected => false;
    'govuk::apps::designprinciples':      vhost_protected => false;
    'govuk::apps::feedback':              vhost_protected => false;
    'govuk::apps::finder_frontend':       vhost_protected => false;
    'govuk::apps::frontend':              vhost_protected => false;
    'govuk::apps::info_frontend':         vhost_protected => false;
    'govuk::apps::licencefinder':         vhost_protected => false;
    'govuk::apps::limelight':             vhost_protected => true;
    'govuk::apps::manuals_frontend':      vhost_protected => false;
    'govuk::apps::service_manual':        vhost_protected => false;
    'govuk::apps::smartanswers':          vhost_protected => false;
    'govuk::apps::specialist_frontend':   vhost_protected => false;
    'govuk::apps::tariff':                vhost_protected => false;
  }

  include govuk::apps::asset_manager
  include govuk::apps::business_support_api
  include govuk::apps::canary_backend
  include govuk::apps::canary_frontend
  include govuk::apps::collections_api
  include govuk::apps::collections_publisher
  include govuk::apps::contacts
  include govuk::apps::content_planner
  include govuk::apps::content_store
  include govuk::apps::content_store::rabbitmq
  include govuk::apps::efg
  include govuk::apps::errbit
  class { 'govuk::apps::external_link_tracker':
    mongodb_nodes => [
      'localhost',
    ]
  }
  include govuk::apps::fact_cave
  include govuk::apps::finder_api
  include govuk::apps::govuk_delivery
  include govuk::apps::hmrc_manuals_api
  include govuk::apps::imminence
  include govuk::apps::kibana
  include govuk::apps::maslow
  include govuk::apps::metadata_api
  include govuk::apps::need_api
  include govuk::apps::need_o_tron # FIXME remove once this has been removed everywhere.
  include govuk::apps::panopticon
  include govuk::apps::publicapi
  include govuk::apps::public_link_tracker
  include govuk::apps::publisher
  include govuk::apps::redirector
  include govuk::apps::release
  class { 'govuk::apps::router':
    mongodb_nodes => [
      'localhost',
    ],
  }
  include govuk::apps::router_api
  include govuk::apps::search
  include govuk::apps::search_admin
  include govuk::apps::short_url_manager
  include govuk::apps::signon
  include govuk::apps::specialist_publisher
  include govuk::apps::static
  include govuk::apps::support
  include govuk::apps::support_api
  include govuk::apps::tariff_admin
  include govuk::apps::tariff_api
  include govuk::apps::transactions_explorer
  include govuk::apps::transition
  include govuk::apps::transition_postgres
  include govuk::apps::travel_advice_publisher
  include govuk::apps::url_arbiter
  class { 'govuk::apps::whitehall':
    configure_admin    => true,
    configure_frontend => true,
    vhost_protected    => false,
  }

  include govuk_java::oracle7::jdk
  include govuk_java::oracle7::jre

  class { 'govuk_java::set_defaults':
    jdk => 'oracle7',
    jre => 'oracle7',
  }

  class { 'govuk_elasticsearch':
    cluster_name       => 'govuk-development',
    heap_size          => '64m',
    number_of_shards   => '1',
    number_of_replicas => '0',
    require            => Class['govuk_java::set_defaults'],
  }

  elasticsearch_old::plugin { 'head':
    install_from => 'mobz/elasticsearch-head',
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

    ['content_planner_development', 'content_planner_test']:
      user     => 'content_planner',
      password => 'content_planner';

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

    [
      'support_contacts_development',
      'support_contacts_test',
    ]:
      user     => 'support_contacts',
      password => 'support_contacts';

    ['tariff_admin_development', 'tariff_admin_test']:
      user     => 'tariff_admin',
      password => 'tariff_admin';

    ['tariff_development', 'tariff_test']:
      user     => 'tariff',
      password => 'tariff';

    ['transition_development', 'transition_test']:
      user     => 'transition',
      password => 'transition',
      collate  => 'utf8_unicode_ci';

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
