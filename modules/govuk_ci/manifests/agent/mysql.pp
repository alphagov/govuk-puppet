# == Class: govuk_ci::agent::mysql
#
# Installs and configures mysql-server
#
class govuk_ci::agent::mysql {
  contain ::govuk_mysql::server

  # We want to run MySQL on a ramdisk, so this creates the directory so that it
  # can be mounted.
  file { '/var/lib/mysql':
    ensure  => directory,
    owner   => 'mysql',
    group   => 'mysql',
    before  => Mount['/var/lib/mysql'],
    require => User['mysql'],
  }

  user { 'mysql':
    ensure => present,
    shell  => '/bin/false',
  }

  # Mount the MySQL datadir in ramdisk, and make sure this is completed before
  # the MySQL class runs. When the MySQL class runs it recreates the datadir
  # as usual
  mount { '/var/lib/mysql':
    ensure   => 'mounted',
    device   => 'tmpfs',
    fstype   => 'tmpfs',
    options  => 'size=2G,noatime',
    remounts => true,
    atboot   => true,
    before   => Class['::govuk_mysql::server'],
    require  => File['/var/lib/mysql'],
  }

  # On boot, the server will not have a working MySQL install until Puppet runs,
  # so we should ensure that this runs after every boot
  file { '/etc/cron.d/run_puppet_on_boot':
    ensure  => present,
    content => '@reboot root /usr/local/bin/govuk_puppet',
  }

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

  file { '/etc/mysql/conf.d/custom.cnf':
    ensure  => present,
    source  => 'puppet:///modules/govuk_ci/mysql_custom_config',
    require => Class['::govuk_mysql::server'],
  }
}
