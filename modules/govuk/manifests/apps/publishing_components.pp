# == Class: govuk::apps::publishing_components
#
# An application that wraps the publishing_components gem so that
# components can be worked on without having to mount the gem in
# other Rails apps.
#
# === Parameters
#
# [*port*]
#   The port that publishing_components is served on.
#
class govuk::apps::publishing_components (
  $port,
) {
  $app_name = 'publishing-components'

  govuk::app { $app_name:
    app_type          => 'procfile',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/component-guide',
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar {
    "${title}-PLEK_SERVICE_STATIC_URI":
      app     => $app_name,
      varname => 'PLEK_SERVICE_STATIC_URI',
      value   => 'assets.publishing.service.gov.uk';
  }
}
