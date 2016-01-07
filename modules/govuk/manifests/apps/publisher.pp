# == Class: govuk::apps::publisher
#
# Set up the publisher app
#
# === Parameters
#
# [*port*]
#   The port which the app runs on.
#   Default: 3000
#
# [*data_import_passive_check*]
#   Boolean, whether we should be monitoring publisher's local
#   authority data import
#   Default: false
#
# [*enable_procfile_worker*]
#   Boolean, whether the procfile worker should be enabled
#   Default: true
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
class govuk::apps::publisher(
    $port = '3000',
    $data_import_passive_check = false,
    $enable_procfile_worker = true,
    $publishing_api_bearer_token = undef,
  ) {

  govuk::app { 'publisher':
    app_type            => 'rack',
    port                => $port,
    vhost_ssl_only      => true,
    health_check_path   => '/healthcheck',
    expose_health_check => false,
    json_health_check   => true,
    log_format_is_json  => true,
    asset_pipeline      => true,
    deny_framing        => true,
    nginx_extra_config  => '
    proxy_set_header X-Sendfile-Type X-Accel-Redirect;
    proxy_set_header X-Accel-Mapping /var/apps/publisher/reports/=/raw/;

    # /raw/(.*) is the path mapping sent from the rails application to
    # nginx and is immediately picked up. /raw/(.*) is not available
    # publicly as it is an internal path mapping.
    location ~ /raw/(.*) {
      internal;
      alias /var/apps/publisher/reports/$1;
    }'
  }

  $service_desc = 'publisher local authority data importer error'

  file { '/usr/local/bin/local_authority_import_check':
    ensure  => present,
    mode    => '0755',
    content => template('govuk/local_authority_import_check.erb'),
  }

  file { ['/data/uploads/publisher', '/data/uploads/publisher/reports']:
    ensure => directory,
    mode   => '0775',
    owner  => 'assets',
    group  => 'assets',
  }

  if $data_import_passive_check {
    @@icinga::passive_check { "check-local-authority-data-importer-${::hostname}":
      service_description => $service_desc,
      host_name           => $::fqdn,
      freshness_threshold => 28 * (60 * 60),
    }
  }

  govuk::procfile::worker {'publisher':
    enable_service => $enable_procfile_worker,
  }

  govuk::app::envvar { "${title}-PUBLISHING_API_BEARER_TOKEN":
    app     => 'publisher',
    varname => 'PUBLISHING_API_BEARER_TOKEN',
    value   => $publishing_api_bearer_token,
  }
}
