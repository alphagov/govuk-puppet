# == Class: hosts::production
#
# Manage /etc/hosts entries for various machines
#
# these are real hosts (1-1 mapping between host and service) anything that
# ends .cluster is maintained for backwards compatibility with ec2
#
# === Parameters:
#
# [*apt_mirror_internal*]
#   Point `apt.production.alphagov.co.uk` to `apt-1` within this
#   environment. Instead of going to the Production VSE.
#   Default: false
#
# [*carrenza_vcloud*]
#   Creates an /etc/hosts entry to access the vCloud API from a
#   whitelisted IP without requiring a VPN connection.
#   Default: false
#
# [*releaseapp_host_org*]
#   Whether to create the `release.$app_domain` vhost alias within this environment.
#   Default: false
#
# [*ip_bouncer*]
#   The IP address of the bouncer vse load-balancer
#
# [*ip_api_lb*]
#   The IP address of the API load-balancer
#
# [*ip_backend_lb*]
#   The IP address of the backend load-balancer
#
# [*ip_frontend_lb*]
#   The IP address of the frontend load-balancer
#
# [*ip_licensify_lb*]
#   The IP address of the licensify load-balancer
#
class hosts::production (
  $apt_mirror_internal    = false,
  $carrenza_vcloud        = false,
  $releaseapp_host_org    = false,
  $ip_bouncer             = '127.0.0.1',
  $ip_api_lb              = '127.0.0.1',
  $ip_backend_lb          = '127.0.0.1',
  $ip_frontend_lb         = '127.0.0.1',
  $ip_licensify_lb        = '127.0.0.1',
) {

  $app_domain = hiera('app_domain')

  validate_bool($carrenza_vcloud)

  #management vdc machines
  class { 'hosts::production::management':
    app_domain          => $app_domain,
    apt_mirror_internal => $apt_mirror_internal,
  }

  #router vdc machines
  class { 'hosts::production::router':
    app_domain => $app_domain,
  }

  #frontend vdc machines
  if is_ip_address($ip_frontend_lb) {
    class { 'hosts::production::frontend':
      app_domain     => $app_domain,
      internal_lb_ip => $ip_frontend_lb,
    }
  }

  #api vdc machines
  if is_ip_address($ip_api_lb) {
    class { 'hosts::production::api':
      app_domain     => $app_domain,
      internal_lb_ip => $ip_api_lb,
    }
  }

  #backend vdc machines
  class { 'hosts::production::backend':
    app_domain          => $app_domain,
    releaseapp_host_org => $releaseapp_host_org,
    internal_lb_ip      => $ip_backend_lb,
  }

  # redirector vdc machines
  if is_ip_address($ip_bouncer) {
    class { 'hosts::production::redirector':
      app_domain => $app_domain,
      ip_bouncer => $ip_bouncer,
    }
  }

  # elms (licence finder) vdc machines
  if is_ip_address($ip_licensify_lb) {
    class { 'hosts::production::licensify':
      app_domain     => $app_domain,
      internal_lb_ip => $ip_licensify_lb,
    }
  }

  #efg vdc machines
  govuk::host { 'efg-mysql-master-1':
    ip             => '10.4.0.10',
    vdc            => 'efg',
    legacy_aliases => ['efg.master.mysql'],
  }

  $efg_domain = hiera('efg_domain',"efg.${app_domain}")
  govuk::host { 'efg-frontend-1':
    ip             => '10.4.0.2',
    vdc            => 'efg',
    legacy_aliases => [$efg_domain],
  }
  govuk::host { 'efg-mysql-slave-1':
    ip             => '10.4.0.11',
    vdc            => 'efg',
    legacy_aliases => ['efg.slave.mysql'],
  }

  # 3rd-party hosts
  host { 'gds01prod.aptosolutions.co.uk':
    ip => '185.40.10.139',
  }

  if $carrenza_vcloud{
    host { 'vcloud-no-vpn.carrenza.com':
      ip => '31.210.240.69',
    }
  }

}
