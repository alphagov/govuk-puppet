# == Class govuk::apps::government_frontend::enable_running_in_draft_mode
#
# Enables running government-frontend for serving draft content.
#
# Intended to be used only in development.
# In draft mode government-frontend:
#
# 1. runs on a different port: 3126
# 2. is served via a different nginx vhost: draft-government-frontend.dev.gov.uk
#
class govuk::apps::government_frontend::enable_running_in_draft_mode(
  $content_store = '',
) {
  $draft_government_frontend_port = 3126
  $app_name = 'draft-government-frontend'
  $parent_app_name = 'government-frontend'
  $app_domain = hiera('app_domain')

  govuk::app::nginx_vhost { $app_name:
    vhost    => "${app_name}.${app_domain}",
    app_port => $draft_government_frontend_port,
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
      value   => $draft_government_frontend_port;
  }
}
