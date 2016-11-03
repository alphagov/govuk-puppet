# == Class: govuk_ci::agent::mysql
#
# Installs and configures mysql-server
#
class govuk_ci::agent::mysql {
  contain ::govuk_mysql::server

  mysql::db {
    'collections_publisher_test':
      user     => 'collections_pub',
      password => 'collections_publisher',
      require  => Class['::mysql::server'];

    'contacts_test':
      user     => 'contacts',
      password => 'contacts',
      require  => Class['::mysql::server'];

    'content_planner_test':
      user     => 'content_planner',
      password => 'content_planner',
      require  => Class['::mysql::server'];

    [
      'efg_test',
      'efg_test1',
      'efg_test2',
      'efg_test3',
      'efg_test4',
      'efg_test5',
      'efg_test6',
      'efg_test7',
      'efg_test8',
    ]:
      user     => 'efg',
      password => 'efg',
      require  => Class['::mysql::server'];

    'panopticon_test':
      user     => 'panopticon',
      password => 'panopticon',
      require  => Class['::mysql::server'];

    ['release_development', 'release_test']:
      user     => 'release',
      password => 'release',
      require  => Class['::mysql::server'];

    'search_admin_test':
      user     => 'search_admin',
      password => 'search_admin',
      require  => Class['::mysql::server'];

    ['signonotron2_test', 'signonotron2_integration_test']:
      user     => 'signonotron2',
      password => 'signonotron2',
      require  => Class['::mysql::server'];

    'support_contacts_test':
      user     => 'support_contacts',
      password => 'support_contacts',
      require  => Class['::mysql::server'];

    'tariff_admin_test':
      user     => 'tariff_admin',
      password => 'tariff_admin',
      require  => Class['::mysql::server'];

    'tariff_test':
      user     => 'tariff',
      password => 'tariff',
      require  => Class['::mysql::server'];

    [
      'whitehall_development',
      'whitehall_test',
      'whitehall_test1',
      'whitehall_test2',
      'whitehall_test3',
      'whitehall_test4',
      'whitehall_test5',
      'whitehall_test6',
      'whitehall_test7',
      'whitehall_test8',
      'whitehall_test9',
      'whitehall_test10',
      'whitehall_test11',
      'whitehall_test12',
      'whitehall_test13',
      'whitehall_test14',
      'whitehall_test15',
      'whitehall_test16',
    ]:
      user     => 'whitehall',
      password => 'whitehall',
      grant    => ['ALL'],
      require  => Class['::mysql::server'];
  }
}
