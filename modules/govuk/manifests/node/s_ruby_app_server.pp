# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_ruby_app_server {
  include govuk_mysql::libdev
  include mysql::client

  # sprockets-rails, the library which compiles assets, depends on Uglifier,
  # which depends on ExecJS, depends on Node.js
  include nodejs

  package {
    'dictionaries-common': ensure => installed;
    'wbritish-small':      ensure => installed;
    'miscfiles':           ensure => installed;
  }
}
