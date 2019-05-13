# == Class: Govuk_containers::Apps::Router
#
# Runs the router app.
#
class govuk_containers::apps::router (
  $image = 'govuk/router',
  $port = '3054',
  $api_port = '3055',
  $envvars = [],
  $healthcheck_path = undef,
  $enable_ufw = false,
) {
  validate_array($envvars)

  if $enable_ufw {
    @ufw::allow { 'allow-router-reload-from-all':
      port => $api_port,
    }
  }

  govuk_containers::app { 'router':
    image   => $image,
    port    => $port,
    envvars => $envvars,
  }

  # While we pass the port to the govuk_containers::app class, the container
  # appears to also expose the API port so we can do the healthcheck against
  # the API
  if $healthcheck_path {
    @@icinga::check { "check_app_router_up_on_${::hostname}":
      check_command       => "check_app_health!check_app_up!${api_port} ${healthcheck_path}",
      service_description => 'router app healthcheck',
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(app-healthcheck-failed),
    }
  }
}
