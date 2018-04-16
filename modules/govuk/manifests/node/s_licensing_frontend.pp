# == Class: govuk::node::s_licensing_frontend
#
# Sets up app servers for the licensing frontend
#
class govuk::node::s_licensing_frontend inherits govuk::node::s_base {
  include clamav

  class { 'govuk_java::oracle8':
    ensure => absent,
  }

  include govuk_java::openjdk8::jdk
  include govuk_java::openjdk8::jre
  include licensify::apps::licensify
  include licensify::apps::licensing_web_forms

  class { 'govuk_java::set_defaults':
    jdk     => 'openjdk8',
    jre     => 'openjdk8',
    require => [
                Class['govuk_java::openjdk8::jdk'],
                Class['govuk_java::openjdk8::jre'],
              ],
    notify  => [
                Class['licensify::apps::licensify'],
                Class['licensify::apps::licensing_web_forms'],
              ],
  }

  include nginx
}
