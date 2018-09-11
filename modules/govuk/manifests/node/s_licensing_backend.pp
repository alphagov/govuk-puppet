# == Class: govuk::node::s_licensing_backend
#
# Sets up app servers for the licensing backend
#
class govuk::node::s_licensing_backend inherits govuk::node::s_base {
  include clamav

  include govuk_java::openjdk8::jdk
  include govuk_java::openjdk8::jre
  include licensify::apps::licensify_admin
  include licensify::apps::licensify_feed

  class { 'govuk_java::set_defaults':
    jdk     => 'openjdk8',
    jre     => 'openjdk8',
    require => [
                Class['govuk_java::openjdk8::jdk'],
                Class['govuk_java::openjdk8::jre'],
              ],
    notify  => [
                Class['licensify::apps::licensify_admin'],
                Class['licensify::apps::licensify_feed'],
              ],
  }

  include nginx
}
