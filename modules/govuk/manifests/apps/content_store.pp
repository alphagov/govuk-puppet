# == Class govuk::apps::content_store
#
# The central storage of published content on GOV.UK
#
# === Parameters
#
# [*port*]
#   The port the app will listen on.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*mongodb_name*]
#   The mongo database to be used. Overriden in development
#   to be 'content_store_development'.
#   Default: 'content_store_production'
#
# [*enable_running_in_draft_mode*]
#   Intended to be used only during development.
#   Enables running content-store for storing draft content.
#   In draft mode content-store:
#
#   1. runs on a different port: 3100
#   2. writes to a different mongo database: draft_content_store_development
#   3. is served via a different nginx vhost: draft-content-store.dev.gov.uk
#   4. prepends [DRAFT] to rails application log entries
#
class govuk::apps::content_store(
  $port = 3068,
  $mongodb_nodes,
  $mongodb_name = 'content_store_production',
  $enable_running_in_draft_mode = false,
) {
  govuk::app { 'content-store':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  validate_array($mongodb_nodes)

  if $mongodb_nodes != [] {
    $mongodb_nodes_string = join($mongodb_nodes, ',')
    govuk::app::envvar { "${title}-MONGODB_URI":
      app     => 'content-store',
      varname => 'MONGODB_URI',
      value   => "mongodb://${mongodb_nodes_string}/${mongodb_name}",
    }
  }

  if $enable_running_in_draft_mode {
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
      'GOVUK_APP_NAME':
        value => $app_name;
      'GOVUK_APP_LOGROOT':
        value => "/var/log/${app_name}";
      'DRAFT':
        value => '1';
      'PORT':
        value => $draft_content_store_port;
      'MONGODB_URI':
        value => 'mongodb://localhost/draft_content_store_development';
    }
  }
}
