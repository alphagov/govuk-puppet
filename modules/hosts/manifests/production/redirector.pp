# == Class: hosts::production::redirector
#
# Manage /etc/hosts entries specific to machines in the redirector vDC
#
# === Parameters:
#
# [*app_domain*]
#   Domain to be used in vhost aliases
#
# [*ip_bouncer*]
#   The IP address of the bouncer vse load-balancer
#
class hosts::production::redirector (
  $app_domain,
  $ip_bouncer,
) {

  Govuk::Host {
    vdc => 'redirector',
  }

  govuk::host { 'bouncer-1':
    ip  => '10.6.0.4',
  }
  govuk::host { 'bouncer-2':
    ip  => '10.6.0.5',
  }
  govuk::host { 'bouncer-3':
    ip  => '10.6.0.6',
  }
  govuk::host { 'bouncer-vse-lb':
    ip  => $ip_bouncer,
  }
}
