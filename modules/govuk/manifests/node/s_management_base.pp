class govuk::node::s_management_base {
  include apt
  include ssh

  include govuk::node::s_ruby_app_server

  include govuk::deploy
  include govuk::testing_tools

  include clamav
  include imagemagick
  include mongodb::server
  include nodejs
  include solr

  elasticsearch::node { "govuk-${::govuk_platform}":
    number_of_replicas => '0'
  }

  class { 'mongodb::configure_replica_set':
    members => ['localhost']
  }

  $mysql_password = extlookup('mysql_root', '')
  class { 'mysql::server':
    root_password => $mysql_password
  }

  mysql::server::db {
    'datainsights_todays_activity_test':
      user          => 'datainsight',
      password      => '',
      root_password => $mysql_password;
    'datainsight_weekly_reach_test':
      user          => 'datainsight',
      password      => '',
      root_password => $mysql_password;
    'datainsight_insidegov_test':
      user          => 'datainsight',
      password      => '',
      root_password => $mysql_password;
    'efg_test':
      user          => 'efg',
      password      => 'efg',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'efg_test1':
      user          => 'efg',
      password      => 'efg',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'efg_test2':
      user          => 'efg',
      password      => 'efg',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'efg_test3':
      user          => 'efg',
      password      => 'efg',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'efg_test4':
      user          => 'efg',
      password      => 'efg',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'panopticon_test':
      user          => 'panopticon',
      password      => 'panopticon',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'release_development':
      user          => 'release',
      password      => 'release',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'release_test':
      user          => 'release',
      password      => 'release',
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
    'tariff_test':
      user          => 'tariff',
      password      => 'tariff',
      remote_host   => 'localhost',
      root_password => $mysql_password;
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
    'whitehall_test1':
      user          => 'whitehall',
      password      => 'whitehall',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'whitehall_test2':
      user          => 'whitehall',
      password      => 'whitehall',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'whitehall_test3':
      user          => 'whitehall',
      password      => 'whitehall',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'whitehall_test4':
      user          => 'whitehall',
      password      => 'whitehall',
      remote_host   => 'localhost',
      root_password => $mysql_password;
  }
}
