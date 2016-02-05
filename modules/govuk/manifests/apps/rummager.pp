# == Class govuk::apps::rummager
#
# The main search application
#
# Note: this currently duplicates a lot of govuk::apps::search.  This class
# will be applied to a new set of servers, and will allow us to run 2 versions
# of rummager at the same time while we migrate to elasticsearch 1.4.  Once the
# migration is complete, the legacy govuk:apps::search class will be removed.
#
# === Parameters
#
# [*port*]
#   The port the app will listen on.
#   Default: 3009
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker service.
#   Default: true
#
# [*enable_publishing_api_document_indexer*]
#   Whether to enable the procfile indexing service.
#   Default: false
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*aws_s3_key*]
#   AWS access key for uploading API search index snapshots
#   Default: undef
#
# [*aws_s3_secret*]
#   AWS access secret for uploading API search index snapshots
#   Default: undef
#
# [*rabbitmq_hosts*]
#   RabbitMQ hosts to connect to.
#   Default: localhost
#
# [*rabbitmq_user*]
#   RabbitMQ username.
#   Default: rummager
#
# [*rabbitmq_password*]
#   RabbitMQ password.
#   Default: rummager
#
class govuk::apps::rummager(
  $port = '3009',
  $enable_procfile_worker = true,
  $enable_publishing_api_document_indexer = false,
  $publishing_api_bearer_token = undef,
  $aws_s3_key = undef,
  $aws_s3_secret = undef,
  $rabbitmq_hosts = ['localhost'],
  $rabbitmq_user = 'rummager',
  $rabbitmq_password = 'rummager',
) {
  include aspell

  govuk::app { 'rummager':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/unified_search?q=search_healthcheck',

    # support search as an alias for ease of migration from old
    # cluster running in backend VDC.
    vhost_aliases      => ['search'],

    log_format_is_json => true,
    nginx_extra_config => '
    client_max_body_size 500m;

    location ^~ /sitemap.xml {
      expires 1d;
      add_header Cache-Control public;
    }
    location ^~ /sitemaps/ {
      expires 1d;
      add_header Cache-Control public;
    }
    ',
  }

  govuk::app::envvar::rabbitmq { 'rummager':
    hosts    => $rabbitmq_hosts,
    user     => $rabbitmq_user,
    password => $rabbitmq_password,
  }

  govuk::procfile::worker { 'rummager':
    enable_service => $enable_procfile_worker,
  }

  govuk::procfile::worker { 'rummager-publishing-api-document-indexer':
    setenv_as      => 'rummager',
    enable_service => $enable_publishing_api_document_indexer,
    process_type   => 'publishing-api-document-indexer',
  }

  govuk_rabbitmq::monitor_consumers {'rummager-publishing-api-document-indexer':
    rabbitmq_queue => 'rummager_to_be_indexed',
  }

  Govuk::App::Envvar {
    app            => 'rummager',
  }

  govuk::app::envvar {
    "${title}-TAXON_IMPORT_FILE":
      varname => 'TAXON_IMPORT_FILE',
      value   => '/data/apps/rummager/shared/alpha_taxonomy/import_dataset.csv';
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-AWS_S3_KEY":
      varname => 'AWS_S3_KEY',
      value   => $aws_s3_key;
    "${title}-AWS_S3_SECRET":
      varname => 'AWS_S3_SECRET',
      value   => $aws_s3_secret;
  }
}
