class govuk_node::management_server {
  include apt
  include ssh

  include govuk_node::ruby_app_server

  include govuk::deploy
  include govuk::testing_tools

  include imagemagick
  include nodejs
  include solr
  include clamav

  include elasticsearch
  elasticsearch::node { "govuk-${::govuk_platform}": }

  include mongodb::server
  class { 'mongodb::configure_replica_set':
    members => ['localhost']
  }

  $mysql_password = extlookup('mysql_root', '')
  class { 'mysql::server':
    root_password => $mysql_password
  }

  mysql::server::db {
    'whitehall_development':
      user          => 'whitehall',
      password      => 'whitehall',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'whitehall_test':
      user          => 'whitehall',
      password      => 'whitehall',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'contactotron_test':
      user          => 'contactotron',
      password      => 'contactotron',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'panopticon_test':
      user          => 'panopticon',
      password      => 'panopticon',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'signonotron2_test':
      user          => 'signonotron2',
      password      => 'signonotron2',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'signonotron2_integration_test':
      user          => 'signonotron2',
      password      => 'signonotron2',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'efg_test':
      user          => 'efg',
      password      => 'efg',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'tariff_test':
      user          => 'tariff',
      password      => 'tariff',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'datainsights_todays_activity_test':
      user          => 'datainsight',
      password      => 'datainsight',
      root_password => $mysql_password;
  }
}
