class development {
  include base_packages::unix_tools
  include govuk::testing_tools
  include nginx::development
  include mongodb::server
  include apollo
  include hosts
  include solr
  include apt

  $mysql_password = ''
  include mysql::server
  include mysql::client

  mysql::server::db {
    'fco_development':          user => 'fco',          password => '',           host => 'localhost';
    'needotron_development':    user => 'needotron',    password => '',           host => 'localhost';
    'panopticon_development':   user => 'panopticon',   password => 'panopticon', host => 'localhost';
    'panopticon_test':          user => 'panopticon',   password => 'panopticon', host => 'localhost';
    'contactotron_development': user => 'contactotron', password => '',           host => 'localhost';
    'signonotron_development':  user => 'signonotron',  password => '',           host => 'localhost';
    'signonotron2_development': user => 'signonotron2', password => '',           host => 'localhost';
    'signonotron2_test':        user => 'signonotron2', password => '',           host => 'localhost';
    'whitehall_development':    user => 'whitehall',    password => 'whitehall',  host => 'localhost';
    'whitehall_test':           user => 'whitehall',    password => 'whitehall',  host => 'localhost';
  }

  package {
    'bundler':      ensure => 'installed', provider => gem;
    'foreman':      ensure => '0.27.0',    provider => gem;
    'linecache19':  ensure => 'installed', provider => gem;
    'mysql2':       ensure => 'installed', provider => gem, require => Class['mysql::client'];
    'rails':        ensure => 'installed', provider => gem;
    'passenger':    ensure => 'installed', provider => gem;
    'apache2':      ensure => 'absent';
  }
}
