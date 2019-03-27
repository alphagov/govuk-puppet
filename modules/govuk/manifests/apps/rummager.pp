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
# [*enable_govuk_index_listener*]
#   Whether to enable the procfile worker service for the govuk index.
#   Default: false
#
# [*enable_bulk_reindex_listener*]
#   Whether or not to configure the queue for the rummager bulk indexer
#
# [*enable_publishing_listener*]
#   Whether to enable the procfile indexing service.
#   Default: false
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*email_alert_api_bearer_token*]
#   The bearer token to use when communicating with Email Alert API.
#   Default: undef
#
# [*rabbitmq_hosts*]
#   RabbitMQ hosts to connect to.
#   Default: localhost
#
# [*rabbitmq_user*]
#   RabbitMQ username.
#   This is a required parameter
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
# [*spelling_dependencies*]
#   Install the spelling package dependencies
#
# [*sitemap_generation_time*]
#   A time of day in a format supported by https://github.com/javan/whenever
#
# [*unicorn_worker_processes*]
#   The number of unicorn workers to run for an instance of this app
#
# [*oauth_id*]
#   The OAuth ID used to identify the app to GOV.UK Signon (in govuk-secrets)
#
# [*oauth_secret*]
#   The OAuth secret used to authenticate the app to GOV.UK Signon (in govuk-secrets)
#
# [*rummager_enable*]
#   Whether rummager is enabled or not
#
class govuk::apps::rummager(
  $rabbitmq_user,
  $port = '3009',
  $enable_procfile_worker = true,
  $enable_govuk_index_listener = false,
  $enable_bulk_reindex_listener = false,
  $enable_publishing_listener = false,
  $sentry_dsn = undef,
  $publishing_api_bearer_token = undef,
  $email_alert_api_bearer_token = undef,
  $rabbitmq_hosts = ['localhost'],
  $rabbitmq_password = 'rummager',
  $redis_host = undef,
  $redis_port = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $spelling_dependencies = 'present',
  $elasticsearch_hosts = undef,
  $sitemap_generation_time = '1.10am',
  $unicorn_worker_processes = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $enable_rummager = true,
) {

  $rummager_ensure = $enable_rummager ? {
    true    => present,
    default => absent,
  }

  if $enable_rummager {
    $vhost_aliases = ['search']
    package { ['aspell', 'aspell-en', 'libaspell-dev']:
      ensure => $spelling_dependencies,
    }
  } else {
    $vhost_aliases = []
  }

  govuk::app { 'rummager':
    ensure                   => $rummager_ensure,
    app_type                 => 'rack',
    port                     => $port,
    sentry_dsn               => $sentry_dsn,
    health_check_path        => '/search?q=search_healthcheck',

    # support search as an alias for ease of migration from old
    # cluster running in backend VDC.
    vhost_aliases            => $vhost_aliases,

    log_format_is_json       => true,
    nginx_extra_config       => '
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
    nagios_memory_warning    => $nagios_memory_warning,
    nagios_memory_critical   => $nagios_memory_critical,
    unicorn_worker_processes => $unicorn_worker_processes,
  }

  if $enable_rummager {
    govuk::app::envvar::rabbitmq { 'rummager':
      hosts    => $rabbitmq_hosts,
      user     => $rabbitmq_user,
      password => $rabbitmq_password,
    }

    govuk::app::envvar::redis { 'rummager':
      host => $redis_host,
      port => $redis_port,
    }
  }

  govuk::procfile::worker { 'rummager':
    ensure         => $rummager_ensure,
    enable_service => $enable_procfile_worker,
  }

  $toggled_ensure = $enable_publishing_listener ? {
    true    => $rummager_ensure,
    default => absent,
  }

  $toggled_govuk_index_listener = $enable_govuk_index_listener ? {
    true    => $rummager_ensure,
    default => absent,
  }

  $toggled_bulk_reindex_listener = $enable_bulk_reindex_listener ? {
    true    => $rummager_ensure,
    default => absent,
  }

  govuk::procfile::worker { 'rummager-publishing-queue-listener':
    ensure         => $toggled_ensure,
    setenv_as      => 'rummager',
    enable_service => $enable_publishing_listener,
    process_type   => 'publishing-queue-listener',
  }

  govuk::procfile::worker { 'rummager-govuk-index-queue-listener':
    ensure         => $toggled_govuk_index_listener,
    setenv_as      => 'rummager',
    enable_service => $enable_govuk_index_listener,
    process_type   => 'govuk-index-queue-listener',
  }

  govuk::procfile::worker { 'rummager-bulk-reindex-queue-listener':
    ensure         => $toggled_bulk_reindex_listener,
    setenv_as      => 'rummager',
    enable_service => $enable_bulk_reindex_listener,
    process_type   => 'bulk-reindex-queue-listener',
  }

  if $enable_rummager {
    Govuk::App::Envvar {
      app            => 'rummager',
    }

    govuk::app::envvar {
      "${title}-PUBLISHING_API_BEARER_TOKEN":
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
    }

    govuk::app::envvar {
      "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
        varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
        value   => $email_alert_api_bearer_token;
    }

    govuk::app::envvar { "${title}-ELASTICSEARCH_URI":
      varname => 'ELASTICSEARCH_URI',
      value   => $elasticsearch_hosts,
    }

    govuk::app::envvar { "${title}-ELASTICSEARCH_HOSTS":
      varname => 'ELASTICSEARCH_HOSTS',
      value   => $elasticsearch_hosts,
    }

    govuk::app::envvar { "${title}-SITEMAP_GENERATION_TIME":
      varname => 'SITEMAP_GENERATION_TIME',
      value   => $sitemap_generation_time,
    }

    govuk::app::envvar {
      "${title}-OAUTH_ID":
        varname => 'OAUTH_ID',
        value   => $oauth_id;
      "${title}-OAUTH_SECRET":
        varname => 'OAUTH_SECRET',
        value   => $oauth_secret;
      "${title}-XRAY_SAMPLE_RATE":
        varname => 'XRAY_SAMPLE_RATE',
        value   => '1.0';
    }
  }
}
