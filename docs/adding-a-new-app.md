[govuk-secrets]: https://github.com/alphagov/govuk-secrets

# Adding a new app to GOV.UK (Rails+PostgreSQL)

Create a new file in `modules/govuk/manifests/apps` named `my_app.pp`:

```
# == Class: govuk::apps::myapp
#
# Read more: https://github.com/alphagov/myapp
#
# === Parameters
# [*port*]
#   What port the app should run on.
#
# [*enabled*]
#   Whether to install or uninstall the app. Defaults to true (install on all enviroments)
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions (in govuk-secrets)
#
# [*sentry_dsn*]
#   The app-specific URL used by Sentry to report exceptions (in govuk-secrets)
#
# [*oauth_id*]
#   The OAuth ID used to identify the app to GOV.UK Signon (in govuk-secrets)
#
# [*oauth_secret*]
#   The OAuth secret used to authenticate the app to GOV.UK Signon (in govuk-secrets)
#
# [*db_hostname*]
#   The hostname of the database server to use for in DATABASE_URL environment variable
#
# [*db_username*]
#   The username to use for the DATABASE_URL environment variable
#
# [*db_password*]
#   The password to use for the DATABASE_URL environment variable
#
# [*db_port*]
#   The port of the database server to use in the DATABASE_URL.
#   Default: undef
#
# [*db_allow_prepared_statements*]
#   The ?prepared_statements= parameter to use in the DATABASE_URL.
#   Default: undef
#
# [*db_name*]
#   The database name to use for the DATABASE_URL environment variable
#
class govuk::apps::myapp (
  $port,
  $enabled = true,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $db_username = 'myapp',
  $db_hostname = undef,
  $db_port = undef,
  $db_allow_prepared_statements = undef,
  $db_password = undef,
  $db_name = 'myapp_production',
) {
  $app_name = 'myapp'

  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  # see modules/govuk/manifests/app.pp for more options
  govuk::app { $app_name:
    ensure            => $ensure,
    app_type          => 'rack',
    port              => $port,
    sentry_dsn        => $sentry_dsn,
    vhost_ssl_only    => true,
    health_check_path => '/healthcheck', # must return HTTP 200 for an unauthenticated request
    deny_framing      => true,
    asset_pipeline    => true,
  }

  govuk::app::Envvar {
    app               => $app_name,
    ensure            => $ensure,
    notify_service    => $enabled,
  }

  govuk::app::envvar {
    "${title}-SECRET_KEY_BASE":
      varname        => 'SECRET_KEY_BASE',
      value          => $secret_key_base;
    "${title}-OAUTH_ID":
      varname        => 'OAUTH_ID',
      value          => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname        => 'OAUTH_SECRET',
      value          => $oauth_secret;
  }

  govuk::app::envvar::database_url { $app_name:
    type                      => 'postgresql',
    username                  => $db_username,
    password                  => $db_password,
    host                      => $db_hostname,
    port                      => $db_port,
    allow_prepared_statements => $db_allow_prepared_statements,
    database                  => $db_name,
 }
}
```

Also add a file in `modules/govuk/manifests/apps/my_app` named `db.pp`:

```
# == Class: govuk::apps::myapp::db
#
# === Parameters
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
# [*allow_auth_from_lb*]
#   Whether to allow this user to authenticate for this database from
#   the load balancer using its password.
#   Default: false
#
# [*lb_ip_range*]
#   Network range for the load balancer.
#
# [*rds*]
#   Whether to use RDS i.e. when running on AWS
#
# [*username*]
#   The DB instance username.
#
# [*password*]
#   The DB instance password.
#
# [*db_name*]
#   The DB instance name.
#
class govuk::apps::myapp::db (
  $backend_ip_range = '10.3.0.0/16',
  $allow_auth_from_lb = false,
  $lb_ip_range = undef,
  $rds = false,
  $username = 'myapp',
  $password = undef,
  $name = 'myapp_production',
) {
  govuk_postgresql::db { $db_name:
    user                    => $username,
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
    allow_auth_from_lb      => $allow_auth_from_lb,
    lb_ip_range             => $lb_ip_range,
    rds                     => $rds,
  }
}
```

Find the next available port number by looking in `hieradata_aws/common.yaml`
and finding the block of port numbers for the existing apps.

```
# hieradata/common.yaml
govuk::apps::myapp::port: 999999

# hieradata_aws/common.yaml
govuk::apps::myapp::port: 999999
```

Start with the following configuration for the app module variables.

```
# hieradata/common.yaml
govuk::apps::myapp::db_hostname: "postgresql-primary-1.backend"
govuk::apps::myapp::db_port: 6432
govuk::apps::myapp::db_allow_prepared_statements: false
govuk::apps::myapp::db::backend_ip_range: "%{hiera('environment_ip_prefix')}.3.0/24"

# hieradata_aws/common.yaml
govuk::apps::myapp::db_hostname: "postgresql-primary"
govuk::apps::myapp::db::backend_ip_range: "%{hiera('environment_ip_prefix')}.3.0/24"
govuk::apps::myapp::db::allow_auth_from_lb: true
govuk::apps::myapp::db::lb_ip_range: "%{hiera('environment_ip_prefix')}.0.0/16"
govuk::apps::myapp::db::rds: true

# hieradata/vagrant_credentials.yaml
govuk::apps::myapp::db_password: '...'
```

Check if your app appears in these files (use existing apps as examples).

  * hieradata/common.yaml (node_class)
  * hieradata/common.yaml (deployable_applications)
  * hieradata/common.yaml (govuk_ci::master::pipeline_jobs)
  * hieradata/common.yaml (grafana::dashboards::application_dashboards)
  * hieradata/common.yaml (hosts::production::backend::app_hostnames)
  * hieradata_aws/common.yaml (node_class)
  * hieradata_aws/common.yaml (deployable_applications)
  * hieradata_aws/common.yaml (grafana::dashboards::application_dashboards)
  * modules/govuk/manifests/node/s_db_admin.pp
  * modules/govuk/manifests/node/s_postgresql_base.pp
  * modules/grafana/files/dashboards/processes.json
  * modules/govuk/manifests/node/s_backend_lb.pp (if a backend app)
  * modules/govuk/manifests/node/s_frontend_lb.pp (if a frontend app)
  * modules/govuk_jenkins/templates/jobs/data_sync_complete_integration.yaml.erb
