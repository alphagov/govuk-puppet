# == Class: govuk::apps::govuk_nav_prototype
#
# This is a the navigation prototype application
# Read more: https://github.com/alphagov/govuk-nav-prototype
#
# === Parameters
#
# [*port*]
#   The port that govuk-nav-prototype is served on.
#   Default: 3211
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::govuk_nav_prototype (
  $port = 3211,
  $secret_key_base = undef,
) {
  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }
  govuk::app { 'govuk-nav-prototype':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/',
  }
}
