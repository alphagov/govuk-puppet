# == Class: govuk::apps::entity_extractor
#
# Service for extracting named entities from text
#
# === Parameters
#
# [*port*]
#   The port that entity-extractor service listens on.
#   Default: 3096
#
class govuk::apps::entity_extractor(
  $enabled = false,
  $port = 3096,
  $db_password = '',
) {
  if $enabled {
    $app_name = 'entity-extractor'
    govuk::app { $app_name:
      app_type           => 'bare',
      log_format_is_json => true,
      port               => $port,
      command            => "./${app_name}",
      health_check_path  => '/healthcheck',
      vhost_ssl_only     => true,
    }

    govuk::app::envvar {'EXTRACTOR_EXTRACT_ADDR':
      app   => 'entity-extractor',
      value => ":${port}",
    }

    govuk::app::envvar {'EXTRACTOR_DB_CONNECTION_STRING':
      app   => 'entity-extractor',
      value => "host=postgresql-master-1.backend username=${app_name} password=${db_password} dbname=entity-extractor_production sslmode=disable"
    }

    govuk::app::envvar {'EXTRACTOR_LOG_PATH':
      app   => 'entity-extractor',
      value => 'STDERR'
    }
  }
}
