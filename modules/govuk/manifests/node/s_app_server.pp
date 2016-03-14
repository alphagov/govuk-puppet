# == Class: govuk::node::s_app_server
#
# A class containing dependencies for application servers. This class
# is deprecated; nothing new should be added to it and things should
# be removed over time. The classes this includes and the packages it
# installs are too broad.
#
class govuk::node::s_app_server {
  include govuk_mysql::libdev
  include govuk_rbenv::all
  include mysql::client

  # sprockets-rails, the library which compiles assets, depends on Uglifier,
  # which depends on ExecJS, depends on Node.js
  include nodejs
}
