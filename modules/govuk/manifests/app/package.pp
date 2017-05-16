# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define govuk::app::package (
  $vhost_full,
  $repo_name = $title,
  $ensure = 'present',
) {
  validate_re($ensure, '^(present|absent)$', 'Invalid ensure value')

  $ensure_directory = $ensure ? {
    'present' => 'directory',
    'absent'  => 'absent',
  }
  $ensure_file = $ensure ? {
    'present' => 'file',
    'absent'  => 'absent',
  }
  $ensure_link = $ensure ? {
    'present' => 'link',
    'absent'  => 'absent',
  }

  file { "/var/log/${title}":
    ensure => $ensure_directory,
    owner  => 'deploy',
    group  => 'deploy',
    force  => true,
  }

  file { ["/var/log/${title}/app.out.log", "/var/log/${title}/app.err.log"]:
    ensure  => $ensure_file,
    owner   => 'deploy',
    group   => 'deploy',
    require => File["/var/log/${title}"],
  }

  $enable_capistrano_layout = hiera('govuk_app_enable_capistrano_layout', true)

  # If $enable_capistrano_layout is true, we're talking about a deployment
  # environment. Cap should deploy to /var/govuk/APPNAME/release_XXX and
  # symlink from /var/govuk/APPNAME/current
  if $enable_capistrano_layout {
    file { "/var/apps/${title}":
      ensure => $ensure_link,
      target => "/data/vhost/${vhost_full}/current";
    }
    file { "/data/vhost/${vhost_full}":
      ensure => $ensure_directory,
      backup => false,
      owner  => 'deploy',
      group  => 'deploy',
      force  => true,
    }
    file { "/data/apps/${title}":
      ensure => $ensure_link,
      target => "/data/vhost/${vhost_full}",
    }

  # Otherwise, assume the apps are checked out straight into /var/govuk.
  } else {
    file { "/var/apps/${title}":
      ensure => $ensure_link,
      target => "/var/govuk/${repo_name}";
    }
  }


}
