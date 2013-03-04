class govuk::node::s_management_base inherits govuk::node::s_base {
  include apt
  include ssh

  include govuk::node::s_ruby_app_server

  include govuk::deploy
  include govuk::ghe_vpn
  include govuk::testing_tools

  include clamav
  include imagemagick
  include mongodb::server
  include nodejs

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
