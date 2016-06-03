# == Class: govuk::node::s_licensify_frontend
#
# Sets up app servers for the Licensify frontend
#
# === Parameters
#
# [*java8*]
#   Boolean, whether or not to use new upgraded Java. This feature flag
#   should be removed at some point.
#
class govuk::node::s_licensify_frontend (
  $java8 = false,
) inherits govuk::node::s_base {

  include clamav

  if $java8 {
    include govuk_java::oracle8
  } else {
    include govuk_java::oracle7::jdk
  }

  include nginx
  include licensify::apps::licensify
  include licensify::apps::licensing_web_forms
}
