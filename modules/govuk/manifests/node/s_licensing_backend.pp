# == Class: govuk::node::s_licensing_backend
#
# Sets up app servers for the licensing backend
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   The hostname of the local aptly mirror.
#
class govuk::node::s_licensing_backend (
  $apt_mirror_hostname,
) inherits govuk::node::s_base {
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

  apt::source { 'mongodb32':
    location     => "http://${apt_mirror_hostname}/mongodb3.2",
    release      => 'trusty-mongodb-org-3.2',
    architecture => $::architecture,
    repos        => 'multiverse',
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  package { 'mongodb-org-shell':
    ensure  => latest,
  }

  package { 'mongodb-org-tools':
    ensure  => latest,
  }
}
