# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc

# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*sentry_environment*]
#   The environment to be sent with Sentry exceptions
#

class govuk::apps::router (
  $port = '3054',
  $api_port = 3055,
  $api_healthcheck = '/healthcheck',
  $error_log = '/var/log/router/errors.json.log',
  $mongodb_name,
  $mongodb_nodes,
  $mongodb_username = '',
  $mongodb_password = '',
  $mongodb_params = '',
  $sentry_dsn = undef,
  $sentry_environment = undef,

  # These are only overridden in the dev VM to allow www.dev.gov.uk to go through the router.
  $enable_nginx_vhost = false,
  $vhost_aliases = [],
) {
  $app_name = 'router'

  @ufw::allow { 'allow-router-reload-from-all':
    port => $api_port,
  }

  Govuk::App::Envvar {
    app => 'router',
  }

  govuk::app::envvar::mongodb_uri { $app_name:
    hosts    => $mongodb_nodes,
    database => $mongodb_name,
    username => $mongodb_username,
    password => $mongodb_password,
    params   => $mongodb_params,
    varname  => 'ROUTER_MONGO_URL',
  }

  govuk::app::envvar {
    "${title}-ROUTER_PUBADDR":
      value   => "localhost:${port}",
      varname => 'ROUTER_PUBADDR';
    "${title}-ROUTER_APIADDR":
      value   => ":${api_port}",
      varname => 'ROUTER_APIADDR';
    "${title}-ROUTER_MONGO_DB":
      value   => $mongodb_name,
      varname => 'ROUTER_MONGO_DB';
    "${title}-ROUTER_ERROR_LOG":
      value   => $error_log,
      varname => 'ROUTER_ERROR_LOG';
    "${title}-ROUTER_BACKEND_HEADER_TIMEOUT":
      value   => '20s',
      varname => 'ROUTER_BACKEND_HEADER_TIMEOUT';
    "${title}-ROUTER_BACKEND_SENTRY_ENVIRONMENT":
      value   => $sentry_environment,
      varname => 'SENTRY_ENVIRONMENT';
  }

  govuk::app { 'router':
    app_type                            => 'bare',
    command                             => './router',
    port                                => $port,
    enable_nginx_vhost                  => $enable_nginx_vhost,
    vhost_aliases                       => $vhost_aliases,
    nagios_memory_warning               => 900,
    nagios_memory_critical              => 1100,
    sentry_dsn                          => $sentry_dsn,
    local_tcpconns_established_warning  => 150,
    local_tcpconns_established_critical => 200,
  }

  # We can't pass `health_check_path` to `govuk::app` because it has the
  # reverse proxy port, not the API port. Changing the port would lose us
  # TCP connection stats.
  @@icinga::check { "check_app_router_up_on_${::hostname}":
    check_command       => "check_app_health!check_app_up!${api_port} ${api_healthcheck}",
    service_description => 'router app healthcheck',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(app-healthcheck-failed),
  }

  govuk_logging::logstream { 'router-error-json-log':
    logfile => $error_log,
    tags    => ['error'],
    fields  => {'application' => 'router'},
  }

  @filebeat::prospector { 'router-error-json-log':
    paths  => [$error_log],
    tags   => ['error'],
    fields => {'application' => 'router'},
    json   => {'add_error_key' => true},
  }

}
