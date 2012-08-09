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
  include users

  include govuk::apps::review_o_matic_explore
  include govuk::apps::planner
  include govuk::apps::tariff

  include govuk::deploy
  include govuk::repository
  include govuk::testing_tools

  elasticsearch::node { 'govuk-development':
    heap_size          => '64m',
    number_of_shards   => '1',
    number_of_replicas => '0',
  }

  class { 'nginx':
    node_type => development
  }

  $mysql_password = ''
  class { 'mysql::server':
    root_password => $mysql_password
  }

  mysql::server::db {
    'fco_development':                user => 'fco',          password => '',           host => 'localhost', root_password => $mysql_password;
    'needotron_development':          user => 'needotron',    password => '',           host => 'localhost', root_password => $mysql_password;
    'panopticon_development':         user => 'panopticon',   password => 'panopticon', host => 'localhost', root_password => $mysql_password;
    'panopticon_test':                user => 'panopticon',   password => 'panopticon', host => 'localhost', root_password => $mysql_password;
    'contactotron_development':       user => 'contactotron', password => 'contactotron', host => 'localhost', root_password => $mysql_password;
    'contactotron_test':              user => 'contactotron', password => 'contactotron', host => 'localhost', root_password => $mysql_password;
    'signonotron2_development':       user => 'signonotron2', password => '',           host => 'localhost', root_password => $mysql_password;
    'signonotron2_test':              user => 'signonotron2', password => '',           host => 'localhost', root_password => $mysql_password;
    'signonotron2_integration_test':  user => 'signonotron2', password => '',           host => 'localhost', root_password => $mysql_password;
    'whitehall_development':          user => 'whitehall',    password => 'whitehall',  host => 'localhost', root_password => $mysql_password;
    'whitehall_test':                 user => 'whitehall',    password => 'whitehall',  host => 'localhost', root_password => $mysql_password;
    'efg_development':                user => 'efg',          password => 'efg',        host => 'localhost', root_password => $mysql_password;
    'efg_test':                       user => 'efg',          password => 'efg',        host => 'localhost', root_password => $mysql_password;
    'tariff_development':             user => 'tariff',       password => 'tariff',     host => 'localhost', root_password => $mysql_password;
    'tariff_test':                    user => 'tariff',       password => 'tariff',     host => 'localhost', root_password => $mysql_password;
  }

  package {
    'foreman':        ensure => '0.27.0',    provider => gem;
    'linecache19':    ensure => 'installed', provider => gem;
    'mysql2':         ensure => 'installed', provider => gem, require => Class['mysql::client'];
    'rails':          ensure => 'installed', provider => gem;
    'passenger':      ensure => 'installed', provider => gem;
    'wbritish-small': ensure => installed;
  }
}
