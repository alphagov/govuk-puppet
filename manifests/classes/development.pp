class development {
  include base_packages::unix_tools
  include govuk::testing_tools
  include nginx::development
  include mongodb::server
  include apollo
  include hosts
  include solr
  include apt

  $mysql_password = ""
  include mysql::server
  include mysql::client

  mysql::server::db {
    "fco_development":          user => "fco",          password => "",           host => "localhost";
    "needotron_development":    user => "needotron",    password => "",           host => "localhost";
    "panopticon_development":   user => "panopticon",   password => "panopticon", host => "localhost";
    "panopticon_test":          user => "panopticon",   password => "panopticon", host => "localhost";
    "contactotron_development": user => "contactotron", password => "",           host => "localhost";
    "whitehall_development":    user => "whitehall",    password => "whitehall",  host => "localhost";
    "whitehall_test":           user => "whitehall",    password => "whitehall",  host => "localhost";
  }

  package {
    "bundler":      provider => gem, ensure => "installed";
    "foreman":      provider => gem, ensure => "installed";
    "linecache19":  provider => gem, ensure => "installed";
    "mysql2":       provider => gem, ensure => "installed", require => Class["mysql::client"];
    "rails":        provider => gem, ensure => "installed";
    "passenger":    provider => gem, ensure => "installed";
    "apache2":                       ensure => "absent";
  }
}
