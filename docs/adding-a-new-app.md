[account-api]: https://github.com/alphagov/account-api
[dev-docs]: https://docs.publishing.service.gov.uk/manual/setting-up-new-rails-app.html

# Adding a new Rails app to GOV.UK

See also the developer docs page on [setting up a new Rails application][dev-docs].

In the below code examples and filenames, replace `my-app` and
`my_app` with your application's name.

If your application's name has dashes in it:

- `my-app` should have dashes in it
- `my_app` should have dashes replaced with underscores

For example, the [account-api][] Puppet class file is called
`account_api.pp`, and its `db_name` is `account-api_production`.

## Create the Puppet class definitions

### Create the app class

Create a new file in `modules/govuk/manifests/apps` named `my_app.pp`.

First add the Puppet class documentation:

```puppet
# == Class: govuk::apps::my_app
#
# Read more: https://github.com/alphagov/my-app
#
# === Parameters
# [*port*]
#   What port the app should run on.
#
# [*enabled*]
#   Whether to install or uninstall the app. Defaults to true (install on all enviroments)
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions
#
# [*sentry_dsn*]
#   The app-specific URL used by Sentry to report exceptions
#
```

If your app uses GDS-SSO for authentication, include the `oauth_`
parameters:

```puppet
# [*oauth_id*]
#   The OAuth ID used by GDS-SSO to identify the app to GOV.UK Signon
#
# [*oauth_secret*]
#   The OAuth secret used by GDS-SSO to authenticate the app to GOV.UK Signon
#
```

If your app uses a database, include the `db_` parameters:

```puppet
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
# [*db_name*]
#   The database name to use for the DATABASE_URL environment variable
#
```

Then add the class.  Omit the `oauth_` and `db_` parameters if your
app does not need them:

```puppet
class govuk::apps::my_app (
  $port,
  $enabled = true,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $db_username = 'my-app',
  $db_hostname = undef,
  $db_port = undef,
  $db_password = undef,
  $db_name = 'my-app_production',
) {
  $app_name = 'my-app'

  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  # see modules/govuk/manifests/app.pp for more options
  govuk::app { $app_name:
    ensure                     => $ensure,
    app_type                   => 'rack',
    port                       => $port,
    sentry_dsn                 => $sentry_dsn,
    vhost_ssl_only             => true,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
    deny_framing               => true,
    asset_pipeline             => true,
  }

  Govuk::App::Envvar {
    app               => $app_name,
    ensure            => $ensure,
    notify_service    => $enabled,
  }

  govuk::app::envvar {
    "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
  }
```

If your app uses GDS-SSO, set the required environment variables:

```puppet
  govuk::app::envvar {
    "${title}-GDS_SSO_OAUTH_ID":
      varname => 'GDS_SSO_OAUTH_ID',
      value   => $oauth_id;
    "${title}-GDS_SSO_OAUTH_SECRET":
      varname => 'GDS_SSO_OAUTH_SECRET',
      value   => $oauth_secret;
  }
```

If your app uses a database, set the database URL:

```puppet
  govuk::app::envvar::database_url { $app_name:
    type     => 'postgresql',
    username => $db_username,
    password => $db_password,
    host     => $db_hostname,
    port     => $db_port,
    database => $db_name,
  }
```

Then end the class definition:

```puppet
}
```

### Create the database class

If your app does not use a database, skip this subsection.

Create a new file in `modules/govuk/manifests/apps/my_app` named
`db.pp`, with the following contents:

```puppet
# == Class: govuk::apps::my_app::db
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
class govuk::apps::my_app::db (
  $backend_ip_range = '10.3.0.0/16',
  $allow_auth_from_lb = false,
  $lb_ip_range = undef,
  $rds = false,
  $username = 'my-app',
  $password = undef,
  $db_name = 'my-app_production',
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

Include the class in the `modules/govuk/manifests/nodes/db_admin.pp`
file:

```puppet
-> class { '::govuk::apps::my_app::db': }
```

## Configure the hieradata

### Choose a port number

Find the list of used port numbers by looking in
 `hieradata_aws/common.yaml`, then give your app the next unassigned
 number:

```yaml
govuk::apps::my_app::port: 999999
```

### Configure database access

If your app does not use a database, skip this subsection.

Add the following configuration to `hieradata_aws/common.yaml`:

```yaml
govuk::apps::my_app::db_hostname: "#{your-app-name}-postgres"
govuk::apps::my_app::db::backend_ip_range: "%{hiera('environment_ip_prefix')}.3.0/24"
govuk::apps::my_app::db::allow_auth_from_lb: true
govuk::apps::my_app::db::lb_ip_range: "%{hiera('environment_ip_prefix')}.0.0/16"
govuk::apps::my_app::db::rds: true
```

### Add your application to the list of deployable applications

Add your application to the `deployable_applications` list in
`hieradata_aws/common.yaml`:

```yaml
deployable_applications: &deployable_applications
  my-app: {}
```

### Enable deployments from CI to integration

Add your application to the `govuk_jenkins::jobs::deploy_app_downstream::applications` list in
`hieradata_aws/class/integration/ci_master.yaml`.

```yaml
govuk_jenkins::jobs::deploy_app_downstream::applications:
  my-app: {}
```

### Enable the deployment dashboard

Add your application to the `grafana::dashboards::application_dashboards` lists in:

- `hieradata_aws/common.yaml`
- `hieradata_aws/integration.yaml`

```yaml
grafana::dashboards::application_dashboards:
  my-app: {}
```

### Enable your app in all environments

Add your app to the `apps` list for the relevant `node_class` in:

- `hieradata_aws/common.yaml`
- `hieradata_aws/production.yaml`
- `hieradata_aws/staging.yaml`

```yaml
node_class: &node_class
  machine_class:
    apps:
      - my-app
```

## Deploy Puppet

Once these changes are merged and deployed, you should be able to
deploy your app with the `Deploy_App` Jenkins job.
