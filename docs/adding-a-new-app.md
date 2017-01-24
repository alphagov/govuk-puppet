# Adding a new app to GOV.UK

This Puppet repository defines all the apps which run on GOV.UK.

Create a new file in `modules/govuk/manifests/apps` named `my_app.pp`:

```
# Be sure to include documentation of the class at the top of the file, as
# per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc.
#
# You may wish to copy an existing app, eg. calculators:
# https://github.com/alphagov/govuk-puppet/blob/3e926f0d/modules/govuk/manifests/apps/calculators.pp
#
class govuk::apps::my_app (
  $port = 3456,
) {
  govuk::app { 'my-app':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/',
  }
}
```

The `health_check_path` must be an endpoint on the application returning a
HTTP 200 status for an unauthenticated request. Monitoring checks for the application are
configured using this path and fail if the request isn't successful.

If your app uses the default web rails web server (on the the GOV.UK stack, this is [Unicorn](https://rubygems.org/gems/unicorn/versions/5.1.0)), you will need to add an entry for `secret_key_base`.

```
if $secret_key_base != undef {
  govuk::app::envvar { "${title}-SECRET_KEY_BASE":
  varname => 'SECRET_KEY_BASE',
  value   => $secret_key_base,
}
```

The `secret_key_base` is used to encrypt user sessions. If it's not defined the application will not start. The value of
`secret_key_base` should be encrypted in the `deployment` repo.

Additional arguments can be specified to configure basic auth, monitoring checks and logging.
These are defined and explained in `modules/govuk/manifests/app.pp`.

## Database setup

Create a file in `modules/govuk/manifests/apps/my_app` named `db.pp`:

```
# Be sure to include documentation of the class at the top of the file, as
# per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc.
#
# You may wish to copy an existing app, eg. calculators:
# https://github.com/alphagov/govuk-puppet/blob/3e926f0d/modules/govuk/manifests/apps/publishing_api/db.pp
#
class govuk::apps::my_app::db (
  $password,
  $backend_ip_range = undef,
) {
  govuk_postgresql::db { 'my_app_production':
    user                    => 'my_app',
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
  }
}
```

Then add the database config to the main application manifest.

```
$db_hostname = undef,
$db_username = 'my_app',
$db_password = undef,
$db_name = 'my_app_production',
.
.
.
.
if $::govuk_node_class != 'development' {
 govuk::app::envvar::database_url { $app_name:
   type     => 'postgresql',
   username => $db_username,
   password => $db_password,
   host     => $db_hostname,
   database => $db_name,
 }
}
```

Add a value for `db_hostname` to the `hieradata/common.yaml` file.

```
# hieradata/common.yaml
govuk::apps::content_performance_manager::db_hostname: "postgresql-primary-1.backend"
```

Add the application to the database servers. For example, if your application has a
postgresql database, add an entry to the `govuk::node::s_postgresql_base` class in `modules/govuk/manifests/node/s_postgresql_base.pp`

```
# modules/govuk/manifests/node/s_postgresql_base.pp
class govuk::node::s_postgresql_base inherits govuk::node::s_base {
  include govuk::apps::my_app::db
  .
  .
  .
}
```

Add a value for `db_password` in each of the credential files in the `deployment` repo.
This entry should be encrypted.

## Environment variables

If your application needs other environment variables, they will need to be added to
the application manifest too.

```
govuk::app::envvar {
  "${title}-ENV_VAR_NAME":
    varname => 'ENV_VAR_NAME',
    value   => $env_var_name;
}
```

The `title` defaults to the name of the application, e.g. `MY-APP`. It's used like a namespace,
so multiple apps can set environment variables with the same name.

## Feature flags

If the app is not ready to be deployed to production, you should use a feature
flag so that it is only enabled in environments where it's expected to be running:

```
# modules/govuk/manifests/apps/my_app.pp
class govuk::apps::my_app (
  $port = 3456,
  $enabled = false,
) {

  if $enabled {
    govuk::app { 'my-app':
      app_type          => 'rack',
      port              => $port,
      vhost_ssl_only    => true,
      health_check_path => '/',
    }
  }
}
```

The flag can be enabled on the development VM by adding the flag to the hiera
development config:

```
# hieradata/development.yaml
govuk::apps::my_app::enabled: true
```

The flag can be enabled in integration by setting it to true in the hiera
config in `hieradata/`:

```
# hieradata/integration.yaml
govuk::apps::my_app::enabled: true
```

Remove the feature flag when you're ready to deploy the app to production, by
setting the default to be `true` and removing all the flags in the hieradata
files.

## Including the app on machines

Once you have created a class for your app, you need to include it in the appropriate nodes.
These can be found in `hieradata/class/`. Additionally, all apps
should be included in the development environment.

```
# hieradata/development.yaml
#   & hieradata/class/[node].yaml
govuk::node::s_base::apps:
  - my_app
```

Most apps will live on the frontend or backend boxes. These boxes use a load balancer, which
also needs to know about your app in its configuration.

Add the name of your app to the list in `modules/govuk/manifests/node/s_frontend_lb.pp` for
the frontend or `modules/govuk/manifests/node/s_backend_lb.pp` for the backend.

Be aware that the backend load balancer configuration is split into two lists, based
on whether the hosts are external or internal.

```
loadbalancer::balance {
  [
    ...
    'my-app',
  ]:
```

Finally, you need to add the host entry for your app to each environment's configuration.

For the development environment:

```
# hieradata/development.yaml
hosts::development::apps:
  - ...
  - my_app
```

For production-like environments, you need to add the app to the appropriate
array in the `hieradata/common.yaml` file.

```
# hieradata/common.yaml
hosts::production::backend::app_hostnames:
  - ...
  - 'my_app'
```
