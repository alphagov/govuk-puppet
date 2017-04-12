# == Class govuk::apps::manuals_frontend::enable_running_in_draft_mode
#
# Enables running manuals-frontend to serve content pages from the draft content store
#
class govuk::apps::manuals_frontend::enable_running_in_draft_mode(
  $content_store = '',
  $port          = '3131',
  $vhost         = 'draft-manuals-frontend',
) {
  $app_name = 'draft-manuals-frontend'

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app { $app_name:
    app_type              => 'rack',
    port                  => $port,
    vhost_ssl_only        => true,
    health_check_path     => '/healthcheck',
    legacy_logging        => false,
    asset_pipeline        => true,
    asset_pipeline_prefix => $app_name,
    vhost                 => $vhost,
  }

  govuk::app::envvar {
    "${title}-PLEK_SERVICE_CONTENT_STORE_URI":
      varname => 'PLEK_SERVICE_CONTENT_STORE_URI',
      value   => $content_store;
    "${title}-PLEK_HOSTNAME_PREFIX":
      varname => 'PLEK_HOSTNAME_PREFIX',
      value   => 'draft-';
  }
}
