# == Class: hosts::production::api
#
# Manage /etc/hosts entries specific to machines in the api vDC
#
# === Parameters:
#
# [*app_domain*]
#   Domain to be used in vhost aliases
#
# [*performanceplatform_public_app_domain*]
#   Domain to be used in vhost aliases to point at Performance Platform.
#   In production, this is the hostname without the `production` part,
#   eg www.performance.service.gov.uk
#
# [*performanceplatform_full_app_domain*]
#   Domain to be used in vhost aliases to point at Performance Platform.
#
class hosts::production::api (
  $app_domain,
  $performanceplatform_public_app_domain = '',
  $performanceplatform_full_app_domain = '',
) {

  Govuk::Host {
    vdc => 'api',
  }

  govuk::host { 'content-store-1':
    ip  => '10.7.0.11',
  }
  govuk::host { 'content-store-2':
    ip  => '10.7.0.12',
  }
  govuk::host { 'content-store-3':
    ip  => '10.7.0.13',
  }
  govuk::host { 'api-1':
    ip  => '10.7.0.16',
  }
  govuk::host { 'api-2':
    ip  => '10.7.0.17',
  }
  govuk::host { 'api-elasticsearch-1':
    ip  => '10.7.0.25',
  }
  govuk::host { 'api-elasticsearch-2':
    ip  => '10.7.0.26',
  }
  govuk::host { 'api-elasticsearch-3':
    ip  => '10.7.0.27',
  }
  govuk::host { 'api-mongo-1':
    ip  => '10.7.0.21',
  }
  govuk::host { 'api-mongo-2':
    ip  => '10.7.0.22',
  }
  govuk::host { 'api-mongo-3':
    ip  => '10.7.0.23',
  }
  govuk::host { 'api-postgresql-primary-1':
    ip  => '10.7.0.40',
  }
  govuk::host { 'api-postgresql-standby-1':
    ip  => '10.7.0.41',
  }
  govuk::host { 'api-redis-1':
    ip  => '10.7.0.29',
  }
  govuk::host { 'search-1':
    ip  => '10.7.0.4',
  }
  govuk::host { 'search-2':
    ip  => '10.7.0.5',
  }
  govuk::host { 'search-3':
    ip  => '10.7.0.6',
  }
  #api lb vhosts
  govuk::host { 'api-lb-1':
    ip  => '10.7.0.101',
  }
  govuk::host { 'api-lb-2':
    ip  => '10.7.0.102',
  }
  govuk::host { 'api-internal-lb':
    ip             => '10.7.1.2',
    legacy_aliases => [
      "backdrop-read.${app_domain}",
      "backdrop-write.${app_domain}",
      "content-store.${app_domain}",
      "metadata-api.${app_domain}",
      "rummager.${app_domain}",
      "search.${app_domain}",
      "stagecraft.${app_domain}",
    ]
  }
  # FIXME remove this host when testing of performance platform migration is
  # completed. Added to enable testing without updating existing performance
  # platform dns. IP is a fastly ip
  govuk::host { 'performanceplatform-fastly-hack':
    ip             => '185.31.19.249',
    legacy_aliases => [
      "www.${performanceplatform_public_app_domain}",
      "stagecraft.${performanceplatform_full_app_domain}",
    ]
  }
}
