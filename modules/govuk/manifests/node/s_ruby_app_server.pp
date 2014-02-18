class govuk::node::s_ruby_app_server {
  include bundler
  include govuk_mysql::libdev
  include mysql::client
  include nodejs

  package {
    'dictionaries-common': ensure => installed;
    'wbritish-small':      ensure => installed;
    'miscfiles':           ensure => installed;
  }
}
