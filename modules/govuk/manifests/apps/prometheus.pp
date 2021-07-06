# == Class: govuk::apps::prometheus
#
# === Parameters
# [*port*]
#   What port should the app run on?
#
# [*enabled*]
#   Whether to install or uninstall the app. Defaults to true (install on all enviroments)
#
class govuk::apps::prometheus (
  $port = 9090,
  $enabled = false,
) {
  $app_name = 'prometheus'

  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  # Route healthcheck requests (which arrive at nginx on the default vhost)
  # through to Prometheus. We could use govuk::app::config::health_check_path
  # for this, but that's closely coupled with a bunch of other stuff that we
  # don't want, like an Icinga alert which fires whenever the healthcheck fails
  # (not helpful) and forcing a non-standard (for Prometheus) healthcheck path on
  # the front end of the LB (unnecessarily confusing).
  concat::fragment { 'prometheus_lb_healthcheck_live':
    target  => '/etc/nginx/lb_healthchecks.conf',
    content => "location /-/healthy {\n  proxy_pass http://prometheus-proxy/-/healthy;\n}\n",
  }
  concat::fragment { 'prometheus_lb_healthcheck_ready':
    target  => '/etc/nginx/lb_healthchecks.conf',
    content => "location /-/ready {\n  proxy_pass http://prometheus-proxy/-/ready;\n}\n",
  }
}
