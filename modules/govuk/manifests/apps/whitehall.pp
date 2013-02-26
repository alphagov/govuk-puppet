class govuk::apps::whitehall(
  $vhost = 'whitehall',
  $port = 3020,
  $configure_frontend = false,
  $configure_admin = false,
  $vhost_protected
) {

  $app_domain = extlookup('app_domain')

  if $::govuk_platform != 'development' {
    if $configure_frontend == true and $configure_admin == true {
      abort "You should not be configuring whitehall-frontend and whitehall-admin on the same node"
    }
  }

  govuk::app { 'whitehall':
    app_type           => 'rack',
    vhost              => $vhost,
    port               => $port,
    health_check_path  => '/healthcheck',
    enable_nginx_vhost => false;
  }

  if $configure_frontend == true {

    $asset_config_in_platform = $::govuk_platform ? {
      "development" => "
        proxy_set_header Host 'whitehall-admin.${app_domain}';
        proxy_pass http://whitehall-admin.${app_domain};
      ",
      default => "
        expires max;
        add_header Cache-Control public;
      ",
    }

    govuk::app::nginx_vhost { 'whitehall-frontend':
      vhost              => "whitehall-frontend.${app_domain}",
      protected          => $vhost_protected,
      app_port           => $port,
      nginx_extra_config => "
      location /government/assets {
        ${asset_config_in_platform}
      }
      location /government/uploads {
        proxy_set_header Host 'whitehall-admin.${app_domain}';
        proxy_pass http://whitehall-admin.${app_domain};
      }
      "
    }
  }

  if $configure_admin == true {
    include assets

    govuk::app::nginx_vhost { 'whitehall-admin':
      vhost              => "whitehall-admin.${app_domain}",
      app_port           => $port,
      protected          => true,
      intercept_errors   => str2bool(extlookup('whitehall_admin_intercept_errors', 'yes')),
      nginx_extra_config => '
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
        include /etc/nginx/sts.conf;
        try_files $uri @app;
      }
    '
    }

    # Needed for pdfinfo, used to count page numbers in uploaded PDFs
    package { 'poppler-utils':
      ensure => installed,
    }

    file { '/usr/local/bin/govuk_run_delayed_job_worker':
      ensure  => present,
      source  => 'puppet:///modules/govuk/bin/govuk_run_delayed_job_worker',
      mode    => '0755',
      notify  => Service['whitehall-admin-delayed-job-worker'],
    }

    file { "/etc/init/whitehall-admin-delayed-job-worker.conf":
      ensure  => present,
      content => template('govuk/whitehall-admin/whitehall-admin-delayed-job-worker.conf.erb'),
      require => File['/usr/local/bin/govuk_run_delayed_job_worker'],
      notify  => Service['whitehall-admin-delayed-job-worker'],
    }

    service { "whitehall-admin-delayed-job-worker":
      ensure   => running,
    }
  }
}
