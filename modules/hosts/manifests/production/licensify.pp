# == Class: hosts::production::licensify
#
# Manage /etc/hosts entries specific to machines in the licensify vDC
#
# === Parameters:
#
# [*app_domain*]
#   Domain to be used in vhost aliases
#
class hosts::production::licensify (
  $app_domain,
) {

  Govuk::Host {
    vdc => 'licensify',
  }

  govuk::host { 'licensify-frontend-1':
    ip  => '10.5.0.2',
  }
  govuk::host { 'licensify-frontend-2':
    ip  => '10.5.0.3',
  }
  govuk::host { 'licensify-backend-1':
    ip  => '10.5.0.4',
  }
  govuk::host { 'licensify-backend-2':
    ip  => '10.5.0.5',
  }
  govuk::host { 'licensify-mongo-1':
    ip  => '10.5.0.6',
  }
  govuk::host { 'licensify-mongo-2':
    ip  => '10.5.0.7',
  }
  govuk::host { 'licensify-mongo-3':
    ip  => '10.5.0.8',
  }
  govuk::host { 'licensify-lb-1':
    ip  => '10.5.0.101',
  }
  govuk::host { 'licensify-lb-2':
    ip  => '10.5.0.102',
  }

  #licensify load balancer v-shield edge
  govuk::host { 'licensify-internal-lb':
    ip             => '10.5.1.2',
    legacy_aliases => [
      "licensify.${app_domain}",
      "uploadlicence.${app_domain}",
      "licensify-admin.${app_domain}",
      "licensing-web-forms.${app_domain}",
    ],
  }
}
