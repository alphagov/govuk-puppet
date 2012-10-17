class govuk::apps::whitehall_admin( $port = 3026 ) {
  include users::assets

  govuk::app { 'whitehall-admin':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/healthcheck',
    nginx_extra_config => "
      location /government/uploads {
        expires 12h;
        add_header Cache-Control private;
      }
    ",;
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

  mount { "/data/uploads":
    ensure  => "mounted",
    device  => "asset-master.${::govuk_platform}.alphagov.co.uk:/mnt/uploads",
    fstype  => "nfs",
    options => "defaults",
    atboot  => true,
    require => [File["/data/uploads"], Package['nfs-common']],
  }

}
