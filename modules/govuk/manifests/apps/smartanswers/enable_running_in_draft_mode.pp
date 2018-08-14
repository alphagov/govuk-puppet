# == Class govuk::apps::smartanswers::enable_running_in_draft_mode
#
# Enables running smartanswers for serving draft content.
#
# Intended to be used only in development.
# In draft mode smartanswers:
#
# 1. runs on a different port: 3231
# 2. is served via a different nginx vhost: draft-smartanswers.dev.gov.uk
#
class govuk::apps::smartanswers::enable_running_in_draft_mode(
  $content_store = '',
) {
  $draft_smartanswers_port = 3231
  $app_name = 'draft-smartanswers'
  $parent_app_name = 'smartanswers'
  $app_domain = hiera('app_domain')

  govuk::app::nginx_vhost { $app_name:
    vhost    => "${app_name}.${app_domain}",
    app_port => $draft_smartanswers_port,
  }

  # Necessary because we're not creating a govuk::app instance for this.
  file { ["/etc/govuk/${app_name}", "/etc/govuk/${app_name}/env.d"]:
    ensure  => directory,
    purge   => true,
    recurse => true,
    force   => true,
  }

  Govuk::App::Envvar {
    app            => $app_name,
    notify_service => false,
    require        => File["/etc/govuk/${app_name}/env.d"],
  }

  govuk::app::envvar {
    "${title}-GOVUK_APP_LOGROOT":
      varname => 'GOVUK_APP_LOGROOT',
      value   => "/var/log/${app_name}";
    "${title}-GOVUK_APP_NAME":
      varname => 'GOVUK_APP_NAME',
      value   => $app_name;
    "${title}-GOVUK_APP_ROOT":
      varname => 'GOVUK_APP_ROOT',
      value   => "/var/apps/${parent_app_name}";
    "${title}-GOVUK_APP_RUN":
      varname => 'GOVUK_APP_RUN',
      value   => "/var/run/${app_name}";
    "${title}-GOVUK_APP_TYPE":
      varname => 'GOVUK_APP_TYPE',
      value   => 'rack';
    "${title}-GOVUK_GROUP":
      varname => 'GOVUK_GROUP',
      value   => 'deploy';
    "${title}-GOVUK_STATSD_PREFIX":
      varname => 'GOVUK_STATSD_PREFIX',
      value   => "govuk.app.${app_name}.development";
    "${title}-GOVUK_USER":
      varname => 'GOVUK_USER',
      value   => 'deploy';
    "${title}-PLEK_HOSTNAME_PREFIX":
      varname => 'PLEK_HOSTNAME_PREFIX',
      value   => 'draft-';
    "${title}-PLEK_SERVICE_CONTENT_STORE_URI":
      varname => 'PLEK_SERVICE_CONTENT_STORE_URI',
      value   => $content_store;
    "${title}-PORT":
      varname => 'PORT',
      value   => $draft_smartanswers_port;
  }
}
