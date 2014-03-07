class govuk::apps::external_link_tracker (
  $mongodb_nodes,
  $port = 3066,
  $api_port = 3067,
  $api_healthcheck = '/healthcheck',
  $error_log = '/var/log/external-link-tracker/errors.json.log',
  $enabled = false
) {

  if $enabled {
    Govuk::App::Envvar {
      app => 'external-link-tracker',
    }

    govuk::app::envvar {
      'LINK_TRACKER_PUBADDR':
        value   => "localhost:${port}";
      'LINK_TRACKER_APIADDR':
        value   => "localhost:${api_port}";
      'LINK_TRACKER_MONGO_URL':
        value   => join($mongodb_nodes, ',');
    }

    govuk::app { 'external-link-tracker':
      app_type           => 'bare',
      command            => './external-link-tracker',
      port               => $port,
      enable_nginx_vhost => true,
    }

    $app_domain = hiera('app_domain')
    $full_domain = "api-external-link-tracker.${app_domain}"

    nginx::config::vhost::proxy { $full_domain:
      to               => ["localhost:${api_port}"],
      protected        => false,
      ssl_only         => false,
    }

    # We can't pass `health_check_path` to `govuk::app` because it has the
    # reverse proxy port, not the API port. Changing the port would lose us
    # TCP connection stats.
    @@icinga::check { "check_app_external_link_tracker_up_on_${::hostname}":
      check_command       => "check_nrpe!check_app_up!${api_port} ${api_healthcheck}",
      service_description => 'external-link-tracker app running',
      host_name           => $::fqdn,
    }

    govuk::logstream { 'external-link-tracker-error-json-log':
      logfile       => $error_log,
      tags          => ['error'],
      fields        => {'application' => 'external-link-tracker'},
      json          => true,
    }
  }
}
