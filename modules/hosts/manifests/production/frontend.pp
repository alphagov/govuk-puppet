# == Class: hosts::production::frontend
#
# Manage /etc/hosts entries specific to machines in the frontend vDC
#
# === Parameters:
#
# [*app_domain*]
#   Domain to be used in vhost aliases
#
class hosts::production::frontend (
  $app_domain,
) {

  Govuk::Host {
    vdc => 'frontend',
  }

  govuk::host { 'calculators-frontend-1':
    ip  => '10.2.0.11',
  }
  govuk::host { 'calculators-frontend-2':
    ip  => '10.2.0.12',
  }
  govuk::host { 'calculators-frontend-3':
    ip  => '10.2.0.13',
  }
  govuk::host { 'frontend-1':
    ip  => '10.2.0.2',
  }
  govuk::host { 'frontend-2':
    ip  => '10.2.0.3',
  }
  govuk::host { 'frontend-3':
    ip  => '10.2.0.4',
  }
  govuk::host { 'performance-frontend-1':
    ip  => '10.2.0.20',
  }
  govuk::host { 'performance-frontend-2':
    ip  => '10.2.0.21',
  }
  govuk::host { 'whitehall-frontend-1':
    ip  => '10.2.0.5',
  }
  govuk::host { 'whitehall-frontend-2':
    ip  => '10.2.0.6',
  }
  govuk::host { 'whitehall-frontend-3':
    ip  => '10.2.0.10',
  }
  govuk::host { 'whitehall-frontend-4':
    ip  => '10.2.0.14',
  }
  govuk::host { 'whitehall-frontend-5':
    ip  => '10.2.0.15',
  }
  govuk::host { 'whitehall-frontend-6':
    ip  => '10.2.0.16',
  }
  govuk::host { 'whitehall-frontend-7':
    ip  => '10.2.0.17',
  }

  #frontend lb vhosts
  govuk::host { 'frontend-lb-1':
    ip  => '10.2.0.101',
  }
  govuk::host { 'frontend-lb-2':
    ip  => '10.2.0.102',
  }
  govuk::host { 'frontend-internal-lb':
    ip             => '10.2.1.2',
    legacy_aliases => [
      "businesssupportfinder.${app_domain}",
      "calculators.${app_domain}",
      "calendars.${app_domain}",
      "canary-frontend.${app_domain}",
      "collections.${app_domain}",
      "contacts-frontend.${app_domain}",
      "contacts-frontend-old.${app_domain}",
      "courts-frontend.${app_domain}",
      "designprinciples.${app_domain}",
      "feedback.${app_domain}",
      "finder-frontend.${app_domain}",
      "frontend.${app_domain}",
      "government-frontend.${app_domain}",
      "info-frontend.${app_domain}",
      "manuals-frontend.${app_domain}",
      "licencefinder.${app_domain}",
      "publicapi.${app_domain}",
      "public-event-store.${app_domain}",
      "public-link-tracker.${app_domain}",
      "service-manual.${app_domain}",
      "smartanswers.${app_domain}",
      "spotlight.${app_domain}",
      "specialist-frontend.${app_domain}",
      "static.${app_domain}",
      "tariff.${app_domain}",
      "transactions-explorer.${app_domain}",
      "whitehall-frontend.${app_domain}",
    ]
  }
}
