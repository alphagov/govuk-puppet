class govuk::apps::whitehall_admin( $port = undef ) {

  if $port != undef {
    $port_real = $port
  } else {
    $port_real = $::govuk_platform ? {
      "development" => 3020,
      default       => 3026,
    }
  }

  include users::assets

  govuk::app { 'whitehall-admin':
    app_type           => 'rack',
    port               => $port_real,
    health_check_path  => '/healthcheck',
    nginx_extra_config => '
      proxy_set_header X-Sendfile-Type X-Accel-Redirect;
      proxy_set_header X-Accel-Mapping /data/uploads/whitehall/clean-uploads/=/clean/;

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
    ',
    vhost_protected    => true;
  }

  file { "/data/uploads":
    ensure  => 'directory',
    owner   => 'assets',
    group   => 'assets',
    mode    => '0664',
    require => [User['assets'], Group['assets']],
  }

  package { 'nfs-common':
    ensure => installed,
  }

  $app_domain = extlookup('app_domain')

  if $::govuk_platform != 'development' {
    mount { "/data/uploads":
      ensure  => "mounted",
      device  => "asset-master.${app_domain}:/mnt/uploads",
      fstype  => "nfs",
      options => "defaults",
      atboot  => true,
      require => [File["/data/uploads"], Package['nfs-common']],
    }
  }

}
