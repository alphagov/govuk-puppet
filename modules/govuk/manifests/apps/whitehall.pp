#
# [$prevent_single_host] - This manifest will deliberately fail if the frontend and admin are on the same machine
#                          and this flag is not set in hiera
class govuk::apps::whitehall(
  $vhost = 'whitehall',
  $port = 3020,
  $configure_frontend = false,
  $configure_admin = false,
  $vhost_protected,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $prevent_single_host = true,
  $enable_procfile_worker = true,
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

  # Enable raindrops monitoring
  collectd::plugin::raindrops { 'whitehall':
    port => $port,
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
      "
    }
  }

  if $configure_admin == true {
    include assets
    include tika # Used to extract text from file attachments when indexing

    govuk::app::nginx_vhost { 'whitehall-admin':
      vhost                 => "whitehall-admin.${app_domain}",
      app_port              => $port,
      protected             => true,
      deny_framing          => true,
      asset_pipeline        => true,
      asset_pipeline_prefix => 'government/assets',
      hidden_paths          => ['/_raindrops', $health_check_path],
      nginx_extra_config    => '
      proxy_set_header X-Sendfile-Type X-Accel-Redirect;
      proxy_set_header X-Accel-Mapping /data/uploads/whitehall/clean/=/clean/;

      client_max_body_size 500m;

      location ~ /clean/(.*) {
        internal;
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
    '
    }

    govuk::logstream { 'whitehall_scheduled_publishing_json_log':
      logfile => '/var/apps/whitehall/log/production_scheduled_publishing.json.log',
      fields  => {'application' => 'whitehall'},
      json    => true,
    }

    govuk::procfile::worker { 'whitehall-admin':
      setenv_as      => 'whitehall',
      enable_service => $enable_procfile_worker,
    }
  }
}
