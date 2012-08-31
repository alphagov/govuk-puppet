define govuk::app::package (
  $vhost_full,
  $platform
) {
  file { ["/var/log/${title}", "/var/run/${title}"]:
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy';
  }

  file { ["/var/log/${title}/app.out.log", "/var/log/${title}/app.err.log"]:
    ensure => file,
    owner  => 'deploy',
    group  => 'deploy';
  }

  # In the development environment, assume the repos are checked out straight
  # into /var/govuk.
  if $platform == 'development' {
    file { "/var/apps/${title}":
      ensure => link,
      target => "/var/govuk/${title}";
    }

  # Otherwise, we're talking about a deployment environment. Cap should deploy
  # to /var/govuk/APPNAME/release_XXX and symlink from
  # /var/govuk/APPNAME/current
  } else {
    file { "/var/apps/${title}":
      ensure => link,
      target => "/data/vhost/${vhost_full}/current";
    }
    file { "/data/vhost/${vhost_full}":
      ensure => directory,
      owner  => 'deploy',
      group  => 'deploy';
    }
  }


}
