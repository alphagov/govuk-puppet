# == Class govuk::apps::content_store::enable_running_in_draft_mode
#
# Enables running content-store for storing draft content.
#
# Intended to be used only in development.
# In draft mode content-store:
#
# 1. runs on a different port: 3100
# 2. writes to a different mongo database: draft_content_store_development
# 3. is served via a different nginx vhost: draft-content-store.dev.gov.uk
# 4. prepends [DRAFT] to rails application log entries
#
class govuk::apps::content_store::enable_running_in_draft_mode() {
  $draft_content_store_port = 3100
  $app_name = 'draft-content-store'
  $app_domain = hiera('app_domain')

  govuk::app::nginx_vhost { $app_name:
    vhost    => "${app_name}.${app_domain}",
    app_port => $draft_content_store_port,
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
    "${title}-GOVUK_APP_NAME":
      varname => 'GOVUK_APP_NAME',
      value   => $app_name;
    "${title}-GOVUK_APP_LOGROOT":
      varname => 'GOVUK_APP_LOGROOT',
      value   => "/var/log/${app_name}";
    "${title}-DRAFT":
      varname => 'DRAFT',
      value   => '1';
    "${title}-PORT":
      varname => 'PORT',
      value   => $draft_content_store_port;
    "${title}-PLEK_HOSTNAME_PREFIX":
      varname => 'PLEK_HOSTNAME_PREFIX',
      value   => 'draft-';
  }

  govuk::app::envvar::mongodb_uri { $app_name:
    hosts    => ['localhost'],
    database => 'draft_content_store_development',
  }
}
