# == Class: govuk_ci::agent::mysql
#
# Installs and configures mysql-server
#
class govuk_ci::agent::mysql {
  contain ::govuk_mysql::server

  ensure_packages([
    'libmysqlclient-dev',
  ])

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
  }

  # Whitehall tests create the databases, so we just need to create a user that
  # has access to any whitehall database matching that description
  mysql_user { 'whitehall@%':
    ensure        => 'present',
    password_hash => mysql_password('whitehall'),
  }

  mysql_grant { 'whitehall@%whitehall_%.*':
    user       => 'whitehall@%',
    table      => 'whitehall_%.*',
    privileges => 'ALL',
  }
}
