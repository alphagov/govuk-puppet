define govuk::app::package (
  $vhost_full
) {
  file { "/var/log/${title}":
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy';
  }

  file { ["/var/log/${title}/app.out.log", "/var/log/${title}/app.err.log"]:
    ensure  => file,
    owner   => 'deploy',
    group   => 'deploy',
    require => File["/var/log/${title}"],
  }

  $enable_capistrano_layout = str2bool(extlookup('govuk_app_enable_capistrano_layout', 'yes'))

  # If $enable_capistrano_layout is true, we're talking about a deployment
  # environment. Cap should deploy to /var/govuk/APPNAME/release_XXX and
  # symlink from /var/govuk/APPNAME/current
  if $enable_capistrano_layout {
    file { "/var/apps/${title}":
      ensure => link,
      target => "/data/vhost/${vhost_full}/current";
    }
    file { "/data/vhost/${vhost_full}":
      ensure => directory,
      owner  => 'deploy',
      group  => 'deploy';
    }

  # Otherwise, assume the apps are checked out straight into /var/govuk.
  } else {
    file { "/var/apps/${title}":
      ensure => link,
      target => "/var/govuk/${title}";
    }
  }


}
