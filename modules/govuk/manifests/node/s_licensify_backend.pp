# == Class: govuk::node::s_licensify_backend
#
# Sets up app servers for the Licensify backend
#
# === Parameters
#
# [*java8*]
#   Boolean, whether or not to use new upgraded Java. This feature flag
#   should be removed at some point.
#
class govuk::node::s_licensify_backend (
  $java8 = false,
) inherits govuk::node::s_base {

  include clamav

  if $java8 {
    include govuk_java::oracle8
  } else {
    include govuk_java::oracle7::jdk
  }

  class { 'nginx': }
  class { 'licensify::apps::licensify_admin': }
  class { 'licensify::apps::licensify_feed': }
}
