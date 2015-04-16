# == Class: performance_platform::spotlight_proxy
#
# This class provides an nginx virtual host which listens for requests to
# spotlight from the GOV.UK router and sends them to Performance Platform
# infrastructure using proxy_pass.
#
# This class is different to the performance_platform::spotlight class,
# because the existing Spotlight application deployed to Performance
# Platform infrastructure already has a pre-existing vhost on the frontend-lb box.
# In order to enable a smooth deployment, we're temporarily using this class as
# the vhost to point Spotlight at so that it doesn't clash with an app
# deployment of Spotlight to GOV.UK infrastructure.
#
# === Parameters
#
# [*perfplat_internal_app_domain*]
#   The internal hostname for the Performance Platform depending on
#   environment. 'Internal' means that it includes the environment
#   name in production rather than being public facing.
class performance_platform::spotlight_proxy (
  $perfplat_internal_app_domain = 'production.performance.service.gov.uk',
) {
  $app_domain = hiera('app_domain')

  $app_name = 'spotlight-proxy'

  $vhost_full = "${app_name}.${app_domain}"
  $spotlight_host = "spotlight.${perfplat_internal_app_domain}"

  # Nginx logs
  $logpath = '/var/log/nginx'
  $access_log = "${vhost_full}-access.log"
  $json_access_log = "${vhost_full}-json.event.access.log"
  $error_log = "${vhost_full}-error.log"

  nginx::config::ssl { $vhost_full:
    certtype => 'wildcard_alphagov',
  }
  nginx::config::site { $vhost_full:
    content => template('performance_platform/spotlight-vhost.conf'),
  }
}
