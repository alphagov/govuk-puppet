# == Class govuk::apps::search
#
# This app is rummager deployed to the backend servers (with the vhost search).
#
# This has now been replaced by govuk::apps::rummager running in the API vDC,
# so this now cleans up the old app from the backend servers
#
# FIXME: Remove this class when it's been cleaned up everywhere.
#
class govuk::apps::search( $port = 3009, $enable_delayed_job_worker = true ) {

  govuk::app { 'search':
    ensure             => absent,
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

  # Clean up old delayed-job worker.
  exec {'stop_search_delayed_job_worker':
    command => 'service search-delayed-job-worker stop || /bin/true',
    onlyif  => 'test -f /etc/init/search-delayed-job-worker.conf',
  }
  file { '/etc/init/search-delayed-job-worker.conf':
    ensure  => absent,
    require => Exec['stop_search_delayed_job_worker'],
  }
}
