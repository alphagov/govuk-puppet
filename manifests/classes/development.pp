class development {
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
  include clamav
  include rabbitmq

  include govuk::apps::review_o_matic_explore
  include govuk::apps::planner
  include govuk::apps::tariff
  include govuk::apps::feedback
  include govuk::apps::contentapi
  include govuk::apps::publicapi
  include govuk::apps::signon
  include govuk::apps::businesssupportfinder
  include govuk::apps::private_frontend
  include govuk::apps::need_o_tron

  include govuk::deploy
  include govuk::repository
  include govuk::testing_tools

  include datainsight::config::google_oauth

  elasticsearch::node { 'govuk-development':
    heap_size          => '64m',
    number_of_shards   => '1',
    number_of_replicas => '0',
  }

  include nginx

  nginx::config::site { 'default':
    # FIXME: this file probably shouldn't live in the nginx module,
    # can't think of a better place at the moment
    source  => 'puppet:///modules/nginx/development',
  }

  $mysql_password = ''
  class { 'mysql::server':
    root_password => $mysql_password
  }

  mysql::server::db {
    'fco_development':                user => 'fco',          password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'needotron_development':          user => 'needotron',    password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'panopticon_development':         user => 'panopticon',   password => 'panopticon',   root_password => $mysql_password, remote_host => 'localhost';
    'panopticon_test':                user => 'panopticon',   password => 'panopticon',   root_password => $mysql_password, remote_host => 'localhost';
    'signonotron2_development':       user => 'signonotron2', password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'signonotron2_test':              user => 'signonotron2', password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'signonotron2_integration_test':  user => 'signonotron2', password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'whitehall_development':          user => 'whitehall',    password => 'whitehall',    root_password => $mysql_password, remote_host => 'localhost';
    'whitehall_test':                 user => 'whitehall',    password => 'whitehall',    root_password => $mysql_password, remote_host => 'localhost';
    'efg_development':                user => 'efg',          password => 'efg',          root_password => $mysql_password, remote_host => 'localhost';
    'efg_test':                       user => 'efg',          password => 'efg',          root_password => $mysql_password, remote_host => 'localhost';
    'tariff_development':             user => 'tariff',       password => 'tariff',       root_password => $mysql_password, remote_host => 'localhost';
    'tariff_test':                    user => 'tariff',       password => 'tariff',       root_password => $mysql_password, remote_host => 'localhost';
    'datainsights_todays_activity':   user => 'datainsight',  password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'datainsight_weekly_reach':       user => 'datainsight',  password => '',             root_password => $mysql_password, remote_host => 'localhost';
    'datainsights_format_success':    user => 'datainsight',  password => '',             root_password => $mysql_password, remote_host => 'localhost';
  }

  package {
    'foreman':        ensure => '0.27.0',    provider => gem;
    'linecache19':    ensure => 'installed', provider => gem;
    'mysql2':         ensure => 'installed', provider => gem, require => Class['mysql::client'];
    'rails':          ensure => 'installed', provider => gem;
    'passenger':      ensure => 'installed', provider => gem;
    'wbritish-small': ensure => installed;
  }

  file { [ '/var/lib/datainsight-narrative-recorder.json' ]:
    ensure  => present,
    owner   => 'vagrant',
    group   => 'vagrant',
  }
}
