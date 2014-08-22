# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class performance_platform::spotlight (
  $perfplat_internal_app_domain = 'production.performance.service.gov.uk',
  #FIXME #73421574: remove when we are off old preview and it is no longer possible
  #       to access apps directly from the internet
  $vhost_protected = false
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
    # This template is the consumer of vhost_protected
    content => template('performance_platform/spotlight-vhost.conf'),
  }
}
