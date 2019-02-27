# == Class: govuk::node::s_backend_lb
#
# Sets up a backend loadbalancer
#
# === Parameters
#
# [*perfplat_public_app_domain*]
#   The public application domain for the Performance Platform
#
# [*backend_servers*]
#   An array of backend app servers
#
# [*whitehall_backend_servers*]
#   An array of whitehall backend app servers
#
# [*email_alert_api_backend_servers*]
#   An array of email-alert-api backend app servers
#
# [*publishing_api_backend_servers*]
#   An array of publishing-api backend app servers
#
# [*ckan_backend_servers*]
#   An array of CKAN backend app servers
#
# [*search_servers*]
#   An array of search-api app servers
#
# [*maintenance_mode*]
#   Whether the backend should be taken offline in nginx
#
# [*aws_egress_nat_ips*]
#   NAT Gateway Egress IPs from AWS Environment & Internal IP Ranges
#
class govuk::node::s_backend_lb (
  $perfplat_public_app_domain = 'performance.service.gov.uk',
  $backend_servers,
  $whitehall_backend_servers,
  $email_alert_api_backend_servers,
  $publishing_api_backend_servers,
  $whitehall_frontend_servers,
  $aws_egress_nat_ips,
  $search_servers = [],
  $ckan_backend_servers = [],
  $maintenance_mode = false,
  $app_specific_static_asset_routes = {},
  $asset_manager_uploaded_assets_routes = [],
  $whitehall_uploaded_assets_routes = [],
  $assets_carrenza_real_ip_header = '',
  $assets_carrenza_vhost_aliases = [],
  $assets_carrenza_vhost_name = 'assets-carrenza',
  $draft_assets_carrenza_vhost_name = 'draft-assets-carrenza',
){
  include govuk::node::s_base
  include loadbalancer

  $app_domain = hiera('app_domain')

  Loadbalancer::Balance {
    maintenance_mode => $maintenance_mode,
  }

  loadbalancer::balance { 'hmrc-manuals-api':
    error_on_http => true,
    servers       => $backend_servers,
  }

  loadbalancer::balance { [
    'collections-publisher',
    'contacts-admin',
    'content-audit-tool',
    'content-data-admin',
    'content-data-api',
    'content-performance-manager',
    'content-publisher',
    'content-tagger',
    'manuals-publisher',
    'maslow',
    'publisher',
    'release',
    'search-admin',
    'service-manual-publisher',
    'signon',
    'specialist-publisher',
    'short-url-manager',
    'support',
    'travel-advice-publisher',
    ]:
      servers => $backend_servers,
  }

  loadbalancer::balance { [
      'asset-manager',
      'canary-backend',
      'event-store',
      'support-api',
    ]:
      internal_only => true,
      servers       => $backend_servers,
  }

  loadbalancer::balance { [
      'whitehall-admin',
    ]:
      deny_crawlers => true,
      servers       => $whitehall_backend_servers,
  }

  loadbalancer::balance { 'email-alert-api':
      aws_egress_nat_ips => $aws_egress_nat_ips,
      servers            => $email_alert_api_backend_servers,
  }

  loadbalancer::balance { 'email-alert-api-public':
      servers       => $email_alert_api_backend_servers,
  }

  loadbalancer::balance { 'publishing-api':
      aws_egress_nat_ips => $aws_egress_nat_ips,
      servers            => $publishing_api_backend_servers,
  }

  loadbalancer::balance { 'rummager':
      aws_egress_nat_ips => $aws_egress_nat_ips,
      servers            => $search_servers,
  }

  loadbalancer::balance { 'search':
      aws_egress_nat_ips => $aws_egress_nat_ips,
      servers            => $search_servers,
  }

  loadbalancer::balance { 'kibana':
    read_timeout => 5,
    servers      => $backend_servers,
  }

  loadbalancer::balance { [
      'ckan',
    ]:
      deny_crawlers => true,
      servers       => $ckan_backend_servers,
  }

  loadbalancer::balance { [
      'whitehall-frontend',
      'draft-whitehall-frontend',
    ]:
      aws_egress_nat_ips => $aws_egress_nat_ips,
      servers            => $whitehall_frontend_servers,
  }

  nginx::config::vhost::redirect { "backdrop-admin.${app_domain}" :
    to => "https://admin.${perfplat_public_app_domain}/",
  }

  # Allthough there are different staging, integration and production buckets
  # created by Terraform on S3, we do not intend to use them. To avoid confusion
  # we proxy all domains to the production bucket.
  nginx::config::vhost::proxy { "docs.${app_domain}" :
    to        => ['govuk-developer-documentation-production.s3-website-eu-west-1.amazonaws.com'],
    protected => false,
    http_host => 'govuk-developer-documentation-production.s3-website-eu-west-1.amazonaws.com',
  }

  nginx::config::vhost::proxy { "content-api.${app_domain}" :
    to        => ['alphagov.github.io'],
    protected => false,
  }

  nginx::config::vhost::proxy { "content-performance-api.${app_domain}" :
    to        => ['alphagov.github.io'],
    protected => false,
  }

  if ! $::aws_migration {
    # Custom vhost to proxy assets-origin to asset-manager and whitehall in Carrenza
    validate_array($assets_carrenza_vhost_aliases)

    $enable_ssl = hiera('nginx_enable_ssl', true)

    $upstream_ssl = $enable_ssl

    # suspect we want `protected => false` here
    # once appropriate firewalling is in place?
    nginx::config::site { $assets_carrenza_vhost_name:
      content => template('govuk/node/s_backend_lb/assets-carrenza.conf.erb'),
    }

    nginx::config::ssl { $assets_carrenza_vhost_name:
      certtype => 'wildcard_publishing',
    }

    nginx::log {
      "${assets_carrenza_vhost_name}-json.event.access.log":
        json          => true,
        logstream     => present,
        statsd_metric => "${::fqdn_metrics}.nginx_logs.assets-carrenza.http_%{status}",
        statsd_timers => [{metric => "${::fqdn_metrics}.nginx_logs.assets-carrenza.time_request",
                            value => 'request_time'}];
      "${assets_carrenza_vhost_name}-error.log":
        logstream => present;
    }

    $graphite_429_target = "transformNull(stats.${::fqdn_metrics}.nginx_logs.assets-carrenza.http_429,0)"

    @@icinga::check::graphite { "check_nginx_429_assets_on_${::hostname}":
      target              => $graphite_429_target,
      warning             => 3,
      critical            => 5,
      from                => '5minutes',
      desc                => '429 rate for assets-carrenza [in office hours]',
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(nginx-429-too-many-requests),
      notification_period => 'inoffice',
    }
    # Custom vhost to proxy draft-assets-origin to asset-manager and whitehall in Carrenza
    nginx::config::site { $draft_assets_carrenza_vhost_name:
      content => template('govuk/node/s_backend_lb/draft-assets-carrenza.conf.erb'),
    }

    nginx::config::ssl { $draft_assets_carrenza_vhost_name:
      certtype => 'wildcard_publishing',
    }
  }
}
