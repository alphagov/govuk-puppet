class govuk::node::development {
  include base

  include apollo
  include base_packages
  include elasticsearch
  include hosts
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
  include govuk::apps::whitehall_admin
  include govuk::apps::whitehall_frontend
  include govuk::apps::release

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

  mysql::server::db {
    'datainsights_todays_activity':   user => 'datainsight',  password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'datainsight_weekly_reach':       user => 'datainsight',  password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'datainsight_weekly_reach_test':  user => 'datainsight',  password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'datainsights_format_success':    user => 'datainsight',  password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'datainsight_insidegov':          user => 'datainsight',  password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'datainsight_insidegov_test':     user => 'datainsight',  password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'efg_development':                user => 'efg',          password => 'efg',          root_password => $mysql_password, remote_host => 'localhost';
    'efg_test':                       user => 'efg',          password => 'efg',          root_password => $mysql_password, remote_host => 'localhost';
    'efg_test1':                      user => 'efg',          password => 'efg',          root_password => $mysql_password, remote_host => 'localhost';
    'efg_test2':                      user => 'efg',          password => 'efg',          root_password => $mysql_password, remote_host => 'localhost';
    'efg_test3':                      user => 'efg',          password => 'efg',          root_password => $mysql_password, remote_host => 'localhost';
    'efg_test4':                      user => 'efg',          password => 'efg',          root_password => $mysql_password, remote_host => 'localhost';
    'efg_il0':                        user => 'efg',          password => 'efg',          root_password => $mysql_password, remote_host => 'localhost';
    'fco_development':                user => 'fco',          password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'needotron_development':          user => 'needotron',    password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'panopticon_development':         user => 'panopticon',   password => 'panopticon',   root_password => $mysql_password, remote_host => 'localhost';
    'panopticon_test':                user => 'panopticon',   password => 'panopticon',   root_password => $mysql_password, remote_host => 'localhost';
    'release_development':            user => 'release',      password => 'release',      root_password => $mysql_password, remote_host => 'localhost';
    'release_test':                   user => 'release',      password => 'release',      root_password => $mysql_password, remote_host => 'localhost';
    'signonotron2_development':       user => 'signonotron2', password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'signonotron2_test':              user => 'signonotron2', password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'signonotron2_integration_test':  user => 'signonotron2', password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'tariff_development':             user => 'tariff',       password => 'tariff',       root_password => $mysql_password, remote_host => 'localhost';
    'tariff_test':                    user => 'tariff',       password => 'tariff',       root_password => $mysql_password, remote_host => 'localhost';
    'whitehall_development':          user => 'whitehall',    password => 'whitehall',    root_password => $mysql_password, remote_host => 'localhost';
    'whitehall_test':                 user => 'whitehall',    password => 'whitehall',    root_password => $mysql_password, remote_host => 'localhost';
    'whitehall_test1':                user => 'whitehall',    password => 'whitehall',    root_password => $mysql_password, remote_host => 'localhost';
    'whitehall_test2':                user => 'whitehall',    password => 'whitehall',    root_password => $mysql_password, remote_host => 'localhost';
    'whitehall_test3':                user => 'whitehall',    password => 'whitehall',    root_password => $mysql_password, remote_host => 'localhost';
    'whitehall_test4':                user => 'whitehall',    password => 'whitehall',    root_password => $mysql_password, remote_host => 'localhost';
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

  file { '/home/vagrant/.zshenv':
    owner   => vagrant,
    group   => vagrant,
    mode    => '0644',
    content => "# We use xvfb for DISPLAY, so that integration tests can run
export DISPLAY=:99"
  }

  file { '/home/vagrant/.bashrc':
    owner   => vagrant,
    group   => vagrant,
    mode    => '0644',
    source  => 'puppet:///modules/govuk/vagrant_bashrc'
  }
}
