# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::router_api(
  $port = 3056,
  $mongodb_nodes,
  $secret_key_base = undef,
) {

  validate_array($mongodb_nodes)

  govuk::app { 'router-api':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  Govuk::App::Envvar {
    app            => 'router-api',
    notify_service => false, # FIXME: Remove this once we've completed rolling this change out.
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }

  if $mongodb_nodes != [] {
    $mongodb_nodes_string = join($mongodb_nodes, ',')
    govuk::app::envvar { "${title}-MONGODB_URI":
      varname => 'MONGODB_URI',
      value   => "mongodb://${mongodb_nodes_string}/router",
    }
  }
}
