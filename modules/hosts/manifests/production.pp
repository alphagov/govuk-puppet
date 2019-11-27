# == Class: hosts::production
#
# Manage /etc/hosts entries for various machines
#
# these are real hosts (1-1 mapping between host and service) anything that
# ends .cluster is maintained for backwards compatibility with ec2
#
# === Parameters:
#
# [*ip_api_lb*]
#   The IP address of the API load-balancer
#
# [*ip_backend_lb*]
#   The IP address of the backend load-balancer
#
# [*ip_bouncer*]
#   The IP address of the bouncer vse load-balancer
#
# [*ip_draft_api_lb*]
#   The IP address of the Draft API load-balancer
#
# [*ip_frontend_lb*]
#   The IP address of the frontend load-balancer
#
# [*releaseapp_host_org*]
#   Whether to create the `release.$app_domain` vhost alias within this environment.
#   Default: false
#
class hosts::production (
  $ip_api_lb                   = '127.0.0.1',
  $ip_backend_lb               = '127.0.0.1',
  $ip_bouncer                  = '127.0.0.1',
  $ip_draft_api_lb             = '127.0.0.1',
  $ip_frontend_lb              = '127.0.0.1',
  $releaseapp_host_org         = false,
) {

  $app_domain = hiera('app_domain')

  validate_ip_address(
    $ip_api_lb,
    $ip_backend_lb,
    $ip_bouncer,
    $ip_draft_api_lb,
    $ip_frontend_lb,
  )

  #api vdc machines
  class { 'hosts::production::api':
    app_domain           => $app_domain,
    draft_internal_lb_ip => $ip_draft_api_lb,
    internal_lb_ip       => $ip_api_lb,
  }

  #backend vdc machines
  class { 'hosts::production::backend':
    app_domain          => $app_domain,
    releaseapp_host_org => $releaseapp_host_org,
    internal_lb_ip      => $ip_backend_lb,
  }

  class { 'hosts::production::ci': }

  #frontend vdc machines
  class { 'hosts::production::frontend':
    app_domain     => $app_domain,
    internal_lb_ip => $ip_frontend_lb,
  }

  #management vdc machines
  class { 'hosts::production::management': }

  # redirector vdc machines
  class { 'hosts::production::redirector':
    ip_bouncer => $ip_bouncer,
  }

  #router vdc machines
  class { 'hosts::production::router': }

  ## 3rd-party hosts

  host { 'vcloud-no-vpn.carrenza.com':
    ip => '31.210.240.69',
  }
}
