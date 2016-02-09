# Adding a new app to GOV.UK

This Puppet repository defines all the apps which run on GOV.UK.

Create a new file in `modules/govuk/manifests/apps` named `myapp.pp`:

```
# Be sure to include documentation of the class at the top of the file, as
# per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc.
#
# You may wish to copy an existing app, eg. courts-api:
# https://github.com/alphagov/govuk-puppet/blob/c6e940f0/modules/govuk/manifests/apps/courts_api.pp
#
class govuk::apps::myapp( $port = 3456 ) {
  govuk::app { 'myapp':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/',
  }
}
```

The `health_check_path` must be an endpoint on the application returning a
HTTP 200 status for an unauthenticated request. Nagios checks for the application are
configured using this path and fail if the request isn't successful.

Additional arguments can be specified to configure basic auth, nagios checks and logging.
These are defined and explained in `modules/govuk/manifests/app.pp`.

## Feature flags

If the app is not ready to be deployed to production, you should use a feature
flag so that it is only enabled in the preview environment:

```
# modules/govuk/manifests/apps/myapp.pp
class govuk::apps::myapp(
  $port = 3456,
  $enabled = false,
) {

  if $enabled {
    govuk::app { 'myapp':
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
govuk::apps::myapp::enabled: true
```

The flag can be enabled on preview by adding the flag to the hiera preview
config in the [deployment repository](https://github.gds/gds/deployment):

```
# puppet/hieradata/integration.yaml
govuk::apps::myapp::enabled: true
```

When you're ready to deploy the app to production, set the feature flag to
true in staging and production by adding similar configuration in their
`hieradata` files. Then redeploy the version of puppet that is currently live
on that environment. Redeploying the currently live version of puppet avoids
depending on other people's changes to puppet, and works because `hieradata`
is always redeployed from the `master` branch.

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
  - myapp
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
    ..
    "myapp",
  ]:
```

Finally, you need to add the host entry for your app to each environment's configuration.

For the development environment:

```
# hieradata/development.yaml
hosts::development::apps:
  - ...
  - myapp
```

For production-like environments, you need to add the app to the appropriate
array in the `hieradata/common.yaml` file.

```
# hieradata/common.yaml
hosts::production::backend::app_hostnames:
  - ...
  - 'myapp'
```
