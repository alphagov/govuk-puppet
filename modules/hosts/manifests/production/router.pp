# == Class: hosts::production::router
#
# Manage /etc/hosts entries specific to machines in the router vDC
#
# === Parameters:
#
# [*app_domain*]
#   Domain to be used in vhost aliases
#
class hosts::production::router (
  $app_domain,
) {

  Govuk::Host {
    vdc => 'router',
  }

  govuk::host { 'cache-1':
    ip => '10.1.0.2',
  }
  govuk::host { 'cache-2':
    ip => '10.1.0.3',
  }
  govuk::host { 'cache-3':
    ip => '10.1.0.4',
  }
  govuk::host { 'router-backend-1':
    ip => '10.1.0.10',
  }
  govuk::host { 'router-backend-2':
    ip => '10.1.0.11',
  }
  govuk::host { 'router-backend-3':
    ip => '10.1.0.12',
  }

  #router lb vhosts
  govuk::host { 'cache':
    ip              => '10.1.1.1',
    legacy_aliases  => [
      'cache',
      "www.${app_domain}",
      "www-origin.${app_domain}",
      "assets-origin.${app_domain}",
    ],
    service_aliases => ['cache', 'router'],
  }
  govuk::host { 'router-backend-internal-lb':
    ip             => '10.1.1.2',
    legacy_aliases => ["router-api.${app_domain}"],
  }
}
