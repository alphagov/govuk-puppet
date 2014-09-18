# == Class: performance_platform::spotlight
#
# This class provides an nginx virtual host which listens for requests to
# spotlight from the GOV.UK router and sends them to Performance Platform
# infrastructure using proxy_pass.
#
# === Parameters
#
# [*perfplat_internal_app_domain*]
#   The internal hostname for the Performance Platform depending on
#   environment. 'Internal' means that it includes the environment
#   name in production rather than being public facing.
class performance_platform::spotlight (
  $perfplat_internal_app_domain = 'production.performance.service.gov.uk',
) {
  $app_domain = hiera('app_domain')

  $app_name = 'spotlight'

  $vhost_full = "${app_name}.${app_domain}"
  $spotlight_host = "${app_name}.${perfplat_internal_app_domain}"

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
