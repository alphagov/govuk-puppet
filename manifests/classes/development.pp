class development {
  include users

  include govuk::repository
  include govuk::testing_tools
  include govuk::deploy_tools

  include base_packages::unix_tools

  include puppet
  #include devdns

  include mongodb::server
  include apollo
  include solr
  include apt
  include mysql::client
  include nodejs
  include imagemagick

  class  { 'nginx' : node_type => development }

  class {'elasticsearch':
    cluster => 'development'
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
    'contactotron_development':       user => 'contactotron', password => '',           host => 'localhost', root_password => $mysql_password;
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
    'apache2':        ensure => 'absent';
    'wbritish-small': ensure => installed;
  }

  include govuk::apps::review_o_matic_explore
  include govuk::apps::planner
}
