# == Class: govuk::apps::whitehall
#
# Configure the whitehall application
#
# === Parameters
#
# FIXME: Document all class parameters
#
# [*prevent_single_host*]
#   This manifest will deliberately fail if the frontend and admin are on the
#   same machine and this flag is not set in hiera
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
class govuk::apps::whitehall(
  $vhost = 'whitehall',
  $port = '3020',
  $configure_frontend = false,
  $configure_admin = false,
  $vhost_protected,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $prevent_single_host = true,
  $enable_procfile_worker = true,
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
  $procfile_worker_process_count = 1,
) {

  $app_domain = hiera('app_domain')

  $health_check_path = '/healthcheck'

  validate_bool($prevent_single_host)
  if $prevent_single_host {
    if $configure_frontend == true and $configure_admin == true {
      fail('You should not be configuring whitehall-frontend and whitehall-admin on the same node')
    }
  }

  govuk::app { 'whitehall':
    app_type               => 'rack',
    vhost                  => $vhost,
    port                   => $port,
    log_format_is_json     => true,
    health_check_path      => $health_check_path,
    expose_health_check    => false,
    json_health_check      => true,
    depends_on_nfs         => true,
    enable_nginx_vhost     => false,
    nagios_cpu_warning     => 300,
    nagios_cpu_critical    => 400,
    nagios_memory_warning  => $nagios_memory_warning,
    nagios_memory_critical => $nagios_memory_critical,
    unicorn_herder_timeout => 45,
    require                => Package['unzip'],
  }

  if $configure_frontend == true {

    govuk::app::nginx_vhost { 'whitehall-frontend':
      vhost                 => "whitehall-frontend.${app_domain}",
      protected             => $vhost_protected,
      app_port              => $port,
      asset_pipeline        => true,
      asset_pipeline_prefix => 'government/assets',
      nginx_extra_config    => "
      location /government/uploads {
        proxy_set_header Host 'whitehall-admin.${app_domain}';
        proxy_pass https://whitehall-admin.${app_domain};
      }
      ",
    }
  }

  if $configure_admin == true {
    include assets

    govuk::app::nginx_vhost { 'whitehall-admin':
      vhost                 => "whitehall-admin.${app_domain}",
      app_port              => $port,
      protected             => $vhost_protected,
      protected_location    => '/government/admin/fact_check_requests/',
      deny_framing          => true,
      asset_pipeline        => true,
      asset_pipeline_prefix => 'government/assets',
      hidden_paths          => [$health_check_path],
      nginx_extra_config    => '
      proxy_set_header X-Sendfile-Type X-Accel-Redirect;
      proxy_set_header X-Accel-Mapping /data/uploads/whitehall/clean/=/clean/;

      client_max_body_size 500m;

      location ~ /clean/(.*) {
        internal;

        # Whitehall sets a `Link:` header to let upstream clients know how
        # to find the cover page for the attachment:
        # https://github.com/alphagov/whitehall/blob/6c72de9390adcf9b23e90bd37686ce6fb940a41d/app/controllers/attachments_controller.rb#L45
        # but Nginx strips those headers because X-Accel-Redirect is an
        # internal redirect: http://stackoverflow.com/a/24509358/61435
        #
        # In order for the functionality to work correctly, we should restore
        # that header.
        add_header Link $upstream_http_link;

        # Respect X-Frame-Options from Rails application
        add_header X-Frame-Options $upstream_http_x_frame_options;

        alias /data/uploads/whitehall/clean/$1;
      }

      location /government/uploads {
        expires 12h;
        add_header Cache-Control public;
        # Explicitly reinclude Strict-Transport-Security header, as calling
        # add_header above will have reset the set of headers sent by nginx.
        include /etc/nginx/add-sts.conf;
        try_files $uri @app;
      }

      # These are for files we have to upload manually on behalf of
      # departments - see HMRC PAYE tools and Number10 virtual tour
      location /government/uploads/uploaded {
        expires 12h;
        add_header Cache-Control public;
        # Explicitly reinclude Strict-Transport-Security header, as calling
        # add_header above will have reset the set of headers sent by nginx.
        include /etc/nginx/add-sts.conf;
        # Needs to be an alias otherwise it appends the path wrongly.
        alias /data/uploads/whitehall/clean/uploaded;

        # This type of file can change to accomodate new PAYE versions,
        # so it needs a smaller expiry.
        location ~ realtimepayetools-update\.xml {
          expires 30m;
        }
      }

      # Don\'t ask for basic auth on API pages so internal apps can hit them
      # more easily.
      location /api {
        auth_basic off;
        try_files $uri @app;
      }
      location /government/admin/api {
        auth_basic off;
        try_files $uri @app;
      }

      # Don\'t ask for basic auth on SSO API pages so we can sync
      # permissions.
      location /auth/gds {
        auth_basic off;
        try_files $uri @app;
      }

      # Don\'t block access to the overdue healthcheck page.  Icinga needs to be
      # able to access this from the monitoring machine.
      # This is necessary because "/healthcheck*" is blocked by the hidden_paths option above.
      location /healthcheck/overdue {
        try_files $uri @app;
      }
    ',
    }

    nginx::config::vhost::static { "draft-whitehall-frontend.${app_domain}":
      locations => {'/government/uploads' => '/data/uploads/whitehall/clean'},
    }

    govuk_logging::logstream { 'whitehall_scheduled_publishing_json_log':
      logfile => '/var/apps/whitehall/log/production_scheduled_publishing.json.log',
      fields  => {'application' => 'whitehall'},
      json    => true,
    }

    govuk_logging::logstream { 'whitehall_sidekiq_json_log':
      logfile => '/var/apps/whitehall/log/sidekiq.json.log',
      fields  => {'application' => 'whitehall-sidekiq'},
      json    => true,
    }

    govuk::procfile::worker { 'whitehall-admin':
      setenv_as      => 'whitehall',
      enable_service => $enable_procfile_worker,
      process_count  => $procfile_worker_process_count,
    }

    # FIXME: Remove this when Whitehall is using Rack 1.7
    govuk::app::envvar {
      "${title}-RACK_MULTIPART_PART_LIMIT":
          app     => 'whitehall',
          varname => 'RACK_MULTIPART_PART_LIMIT',
          value   => '0';
    }

    # Protocal relative URL so assets in admin are on the same domain but work
    # in production and development. (This is needed for IE8)
    govuk::app::envvar {
      "${title}-GOVUK_ASSET_ROOT":
        app     => 'whitehall',
        varname => 'GOVUK_ASSET_ROOT',
        value   => "//whitehall-admin.${app_domain}";
    }
  }

  govuk::app::envvar::redis { 'whitehall':
    host => $redis_host,
    port => $redis_port,
  }

  govuk::app::envvar {
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      app     => 'whitehall',
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
  }
}
