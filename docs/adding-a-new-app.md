[rds-database-management]: https://github.com/alphagov/govuk-aws/blob/master/doc/guides/rds-database-management.md
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
#   What port should the app run on? Find the next free one in development-vm/Procfile
#
# [*enabled*]
#   Whether to install the app. Don't change the default (false) until production-ready
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
class govuk::apps::myapp (
  $port = 99999999,
  $enabled = false,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $db_hostname = undef,
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
}
```

Also add a file in `modules/govuk/manifests/apps/my_app` named `db.pp`:

```
# == Class: govuk::apps::myapp::db
#
# === Parameters
#
# [*hostname*]
#   The DB instance hostname.
#
# [*user*]
#   The DB instance user.
#
# [*password*]
#   The DB instance password.
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
# [*rds*]
#   Whether to use RDS i.e. when running on AWS
#
class govuk::apps::myapp::db (
  $user = 'myapp',
  $hostname,
  $password,
  $backend_ip_range = '10.3.0.0/16',
  $rds = false,
) {
  govuk_postgresql::db { "${user}_production",
    user                    => $user,
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
    rds                     => $rds,
  }

  if $::govuk_node_class !~ /^development$/ {
    govuk::app::envvar::database_url { $app_name,
      type           => 'postgresql',
      username       => $user,
      password       => $password,
      host           => $hostname,
      database       => "${user}_production"
   }
  }
}
```

Start with the following configuration for the app module variables.

```
# hieradata/common.yaml
govuk::apps::myapp::db_hostname: "postgresql-primary-1.backend"
govuk::apps::myapp::db::backend_ip_range: "%{hiera('environment_ip_prefix')}.3.0/24"

# hieradata_aws/common.yaml
govuk::apps::myapp::db_hostname: "postgresql-primary"
govuk::apps::myapp::db::backend_ip_range: "%{hiera('environment_ip_prefix')}.3.0/24"
govuk::apps::myapp::db::rds: true

# hieradata/development.yaml
# use the module default instead when production-ready
govuk::apps::myapp::enabled: true

# hieradata/integration.yaml
# use the module default instead when production-ready
govuk::apps::myapp::enabled: true

# hieradata/vagrant_credentials.yaml
govuk::apps::myapp::db_password: "%{hiera('govuk::apps::myapp::db::password')}"
govuk::apps::myapp::db::password: '...'
```

Check if your app appears in these files (use existing apps as examples).

  * hieradata/common.yaml (node_class)
  * hieradata/common.yaml (deployable_applications)
  * hieradata/common.yaml (govuk_ci::master::pipeline_jobs)
  * hieradata/common.yaml (grafana::dashboards::deployment_applications)
  * hieradata/common.yaml (hosts::production::backend::app_hostnames)
  * hieradata_aws/common.yaml (node_class)
  * hieradata_aws/common.yaml (deployable_applications)
  * hieradata_aws/common.yaml (grafana::dashboards::deployment_applications)
  * hieradata/development.yaml (hosts::development::apps)
  * modules/govuk/manifests/node/s_db_admin.pp (see docs for [RDS](rds-database-management))
  * modules/govuk/manifests/node/s_postgresql_base.pp
  * modules/grafana/files/dashboards/processes.json
  * modules/govuk/manifests/node/s_backend_lb.pp (if a backend app)
  * modules/govuk/manifests/node/s_frontend_lb.pp (if a frontend app)
  * development-vm/Procfile
  * development-vm/Pinfile
  * development-vm/alphagov_repos
