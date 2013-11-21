class performance_platform::spotlight {
  $app_domain = extlookup('app_domain')
  $perfplat_app_domain = extlookup('perfplat_app_domain', 'perfplat.dev')

  $app_name = 'spotlight'

  $vhost_full = "${app_name}.${app_domain}"
  $spotlight_host = "${app_name}.${perfplat_app_domain}"

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
