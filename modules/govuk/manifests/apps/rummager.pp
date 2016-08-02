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
# [*enable_publishing_listener*]
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
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
class govuk::apps::rummager(
  $port = '3009',
  $enable_procfile_worker = true,
  $enable_publishing_listener = false,
  $publishing_api_bearer_token = undef,
  $aws_s3_key = undef,
  $aws_s3_secret = undef,
  $aws_s3_bucket_name = undef,
  $aws_s3_bucket_region = 'eu-west-1',
  $rabbitmq_hosts = ['localhost'],
  $rabbitmq_user = 'rummager',
  $rabbitmq_password = 'rummager',
  $redis_host = undef,
  $redis_port = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
) {
  include aspell

  govuk::app { 'rummager':
    app_type               => 'rack',
    port                   => $port,
    health_check_path      => '/unified_search?q=search_healthcheck',

    # support search as an alias for ease of migration from old
    # cluster running in backend VDC.
    vhost_aliases          => ['search'],

    log_format_is_json     => true,
    nginx_extra_config     => '
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
    nagios_memory_warning  => $nagios_memory_warning,
    nagios_memory_critical => $nagios_memory_critical,
  }

  govuk::app::envvar::rabbitmq { 'rummager':
    hosts    => $rabbitmq_hosts,
    user     => $rabbitmq_user,
    password => $rabbitmq_password,
  }

  govuk::app::envvar::redis { 'rummager':
    host => $redis_host,
    port => $redis_port,
  }

  govuk::procfile::worker { 'rummager':
    enable_service => $enable_procfile_worker,
  }

  $toggled_ensure = $enable_publishing_listener ? {
    true    => present,
    default => absent,
  }

  govuk::procfile::worker { 'rummager-publishing-queue-listener':
    ensure         => $toggled_ensure,
    setenv_as      => 'rummager',
    enable_service => $enable_publishing_listener,
    process_type   => 'publishing-queue-listener',
  }

  Govuk::App::Envvar {
    app            => 'rummager',
  }

  govuk::app::envvar {
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-AWS_ACCESS_KEY_ID":
      varname => 'AWS_ACCESS_KEY_ID',
      value   => $aws_s3_key;
    "${title}-AWS_SECRET_ACCESS_KEY":
      varname => 'AWS_SECRET_ACCESS_KEY',
      value   => $aws_s3_secret;
    "${title}-AWS_BUCKET_NAME":
      varname => 'AWS_BUCKET_NAME',
      value   => $aws_s3_bucket_name;
    "${title}-AWS_BUCKET_REGION":
      varname => 'AWS_BUCKET_REGION',
      value   => $aws_s3_bucket_region;
  }
}
