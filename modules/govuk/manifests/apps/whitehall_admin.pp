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
      proxy_set_header X-Accel-Mapping /data/uploads/whitehall/clean/=/clean/;

      location ~ /clean/(.*) {
        internal;
        alias /data/uploads/whitehall/clean/$1;
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
