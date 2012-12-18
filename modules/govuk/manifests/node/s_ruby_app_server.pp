class govuk::node::s_ruby_app_server {
  include mysql::client
  include nodejs
  include bundler

  package {
    'rails':               ensure => '3.1.1',   provider => gem, require => Package['build-essential'];
    'mysql2':              ensure => installed, provider => gem, require => Package['libmysqlclient-dev'];
    'rake':                ensure => '0.9.2',   provider => gem;
    'rack':                ensure => '1.3.5',   provider => gem;
    'dictionaries-common': ensure => installed;
    'wbritish-small':      ensure => installed;
    'miscfiles':           ensure => installed;
  }
}
