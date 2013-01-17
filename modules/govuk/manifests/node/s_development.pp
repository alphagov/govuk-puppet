class govuk::node::s_development {
  include base

  include apollo
  include base_packages
  include elasticsearch
  include hosts::development
  include imagemagick
  include mongodb::server
  include mysql::client
  include nodejs
  include puppet
  include solr
  include tmpreaper
  include users
  include users::assets
  include rabbitmq
  include fonts
  include redis

  include govuk::deploy
  include govuk::repository
  include govuk::testing_tools

  include govuk::apps::businesssupportfinder
  include govuk::apps::calendars
  include govuk::apps::canary_frontend
  include govuk::apps::canary_backend
  include govuk::apps::contentapi
  include govuk::apps::datainsight_frontend
  include govuk::apps::designprinciples
  include govuk::apps::efg
  include govuk::apps::errbit
  include govuk::apps::feedback
  include govuk::apps::frontend
  include govuk::apps::imminence
  include govuk::apps::licencefinder
  include govuk::apps::migratorator
  include govuk::apps::need_o_tron
  include govuk::apps::panopticon
  include govuk::apps::planner
  include govuk::apps::publicapi
  include govuk::apps::publisher
  include govuk::apps::redirector
  include govuk::apps::release
  include govuk::apps::review_o_matic_explore
  include govuk::apps::search
  include govuk::apps::signon
  include govuk::apps::smartanswers
  include govuk::apps::static
  include govuk::apps::support
  include govuk::apps::tariff
  include govuk::apps::tariff_api
  include govuk::apps::travel_advice_frontend
  include govuk::apps::travel_advice_publisher
  include govuk::apps::release
  class { 'govuk::apps::whitehall':
    configure_admin    => true,
    configure_frontend => true,
  }

  include datainsight::config::google_oauth

  include java::sun6::jdk
  include java::sun6::jre

  class { 'java::set_defaults':
    jdk => 'sun6',
    jre => 'sun6',
  }

  elasticsearch::node { 'govuk-development':
    heap_size          => '64m',
    number_of_shards   => '1',
    number_of_replicas => '0',
  }

  include nginx

  nginx::config::vhost::default { 'default': }
  nginx::config::site { 'development':
    source => 'puppet:///modules/nginx/development',
  }

  $mysql_password = ''
  class { 'mysql::server':
    root_password => $mysql_password
  }
  include mysql::server::development

  Mysql::Server::Db {
    root_password => $mysql_password,
    remote_host   => 'localhost',
  }

  mysql::server::db {
    [
      'datainsights_todays_activity',
      'datainsight_weekly_reach',
      'datainsight_weekly_reach_test',
      'datainsights_format_success',
      'datainsights_format_success_test',
      'datainsight_insidegov',
      'datainsight_insidegov_test',
    ]:
      user     => 'datainsight',
      password => '';

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

    'fco_development':
      user     => 'fco',
      password => '';

    'needotron_development':
      user     => 'needotron',
      password => '';

    ['panopticon_development', 'panopticon_test']:
      user     => 'panopticon',
      password => 'panopticon';

    ['release_development', 'release_test']:
      user     => 'release',
      password => 'release';

    [
      'signonotron2_development',
      'signonotron2_test',
      'signonotron2_integration_test',
    ]:
      user     => 'signonotron2',
      password => '';

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

  package {
    'foreman':        ensure => '0.27.0',    provider => gem;
    'linecache19':    ensure => 'installed', provider => gem;
    'mysql2':         ensure => 'installed', provider => gem, require => Class['mysql::client'];
    'rails':          ensure => 'installed', provider => gem;
    'wbritish-small': ensure => installed;
  }

  file { [ '/var/lib/datainsight-narrative-recorder.json' ]:
    ensure  => present,
    owner   => 'vagrant',
    group   => 'vagrant',
  }

  file { [ '/var/tmp/datainsight-everything-recorder.json' ]:
    ensure  => present,
    owner   => 'vagrant',
    group   => 'vagrant',
  }

  file { [ '/var/data', '/var/data/datainsight', '/var/data/datainsight/everything' ]:
    ensure  => directory,
    owner   => 'vagrant',
    group   => 'vagrant',
  }

}
