define datainsight::collector (
  $vhost = undef
) {

  # Variable setup
  $app_domain = hiera('app_domain')
  $vhost_real = $vhost ? {
    undef   => "datainsight-${title}-collector",
    default => $vhost
  }
  $vhost_full = "${vhost_real}.${app_domain}"

  include datainsight::config::google_oauth

  file { "/data/vhost/${vhost_full}":
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy';
  }

  file { "/var/apps/${vhost_real}":
    ensure => symlink,
    owner  => 'deploy',
    target => "/data/vhost/${vhost_full}/current"
  }

  file { "/var/log/${vhost_real}":
    ensure => symlink,
    owner  => 'deploy',
    target => "/data/vhost/${vhost_full}/current/log"
  }

  @logrotate::conf { "${vhost_real}-app":
    matches => "/data/vhost/${vhost_full}/shared/log/*.log",
  }

  # Ensure config dir exists
  file { "/etc/govuk/${vhost_real}":
    ensure  => 'directory',
    purge   => true,
    recurse => true,
    force   => true
  }

  # Ensure env dir exists
  file { "/etc/govuk/${vhost_real}/env.d":
    ensure  => 'directory',
    purge   => true,
    recurse => true,
    force   => true
  }
  Govuk::App::Envvar { app => $vhost_real, notify_service => false }
  govuk::app::envvar {
    "${vhost_real}-GOVUK_USER":
      varname => 'GOVUK_USER',
      value   => 'deploy';
    "${vhost_real}-GOVUK_GROUP":
      varname => 'GOVUK_GROUP',
      value   => 'deploy';
    "${vhost_real}-GOVUK_APP_NAME":
      varname => 'GOVUK_APP_NAME',
      value   => $vhost_real;
    "${vhost_real}-GOVUK_APP_ROOT":
      varname => 'GOVUK_APP_ROOT',
      value   => "/var/apps/${vhost_real}";
    "${vhost_real}-GOVUK_APP_LOGROOT":
      varname => 'GOVUK_APP_LOGROOT',
      value   => "/var/log/${vhost_real}";
    "${vhost_real}-GOVUK_STATSD_PREFIX":
      varname => 'GOVUK_STATSD_PREFIX',
      value   => "govuk.app.${vhost_real}.${::hostname}";
  }
}
