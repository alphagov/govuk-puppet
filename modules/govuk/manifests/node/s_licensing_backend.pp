# == Class: govuk::node::s_licensing_backend
#
# Sets up app servers for the licensing backend
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   The hostname of the local aptly mirror.
#
# [*apt_mirror_gpg_key_fingerprint*]
#   The fingerprint of the local aptly mirror.
#
class govuk::node::s_licensing_backend (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
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

  apt::source { 'mongodb41':
    ensure       => 'absent',
    location     => "http://${apt_mirror_hostname}/mongodb4.1",
    release      => 'trusty-mongodb-org-4.1',
    architecture => $::architecture,
    repos        => 'multiverse',
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  apt::source { 'mongodb36':
    location     => "http://${apt_mirror_hostname}/mongodb3.6",
    release      => 'trusty-mongodb-org-3.6',
    architecture => $::architecture,
    repos        => 'multiverse',
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  package { 'mongodb-org-shell':
    ensure  => latest,
  }

  package { 'mongodb-org-tools':
    ensure  => latest,
  }
}
