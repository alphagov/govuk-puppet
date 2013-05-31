class govuk::node::s_management_base inherits govuk::node::s_base {
  include apt
  include ssh
  include rbenv

  include govuk::node::s_ruby_app_server

  include govuk::deploy
  include govuk::ghe_vpn
  include govuk::testing_tools

  include clamav
  include imagemagick
  include mongodb::server
  include nodejs

  rbenv::version { '1.9.3-p392':
    bundler_version => '1.3.5'
  }
  rbenv::alias { '1.9.3':
    to_version => '1.9.3-p392',
  }

  $redis_port = 6379
  $redis_max_memory = 256
  class { 'redis':
    redis_max_memory => "${redis_max_memory}mb",
    redis_port       => $redis_port,
  }

  class { 'elasticsearch':
    cluster_name       => "govuk-${::govuk_platform}",
    number_of_replicas => '0'
  }

  class { 'mongodb::configure_replica_set':
    members => ['localhost']
  }

  $mysql_password = extlookup('mysql_root', '')
  class { 'mysql::server':
    root_password => $mysql_password
  }

  Mysql::Server::Db {
    root_password => $mysql_password,
    remote_host   => 'localhost',
  }

  mysql::server::db {
    [
      'datainsights_todays_activity_test',
      'datainsight_weekly_reach_test',
      'datainsights_format_success_test',
      'datainsight_insidegov_test',
    ]:
      user     => 'datainsight',
      password => '';

    [
      'efg_test',
      'efg_test1',
      'efg_test2',
      'efg_test3',
      'efg_test4',
    ]:
      user     => 'efg',
      password => 'efg';

    'fact_cave_test':
      user     => 'fact_cave',
      password => 'fact_cave';

    'panopticon_test':
      user     => 'panopticon',
      password => 'panopticon';

    ['release_development', 'release_test']:
      user     => 'release',
      password => 'release';

    ['signonotron2_test', 'signonotron2_integration_test']:
      user     => 'signonotron2',
      password => 'signonotron2';

    'tariff_test':
      user     => 'tariff',
      password => 'tariff';

    'transition_test':
      user     => 'transition',
      password => 'transition';

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
}
