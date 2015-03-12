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
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker service.
#
class govuk::apps::rummager(
  $port = 3009,
  $enable_procfile_worker = true,
) {
  include aspell

  govuk::app { 'rummager':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/unified_search?q=search_healthcheck',
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

  govuk::procfile::worker { 'rummager':
    enable_service => $enable_procfile_worker,
  }
}
