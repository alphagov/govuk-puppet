class govuk::apps::whitehall_admin( $port = 3026 ) {
  include users::assets

  govuk::app { 'whitehall-admin':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/healthcheck',
    nginx_extra_config => '
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

  if $govuk_platform != 'development' {
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
