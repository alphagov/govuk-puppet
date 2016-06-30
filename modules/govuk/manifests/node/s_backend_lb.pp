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
# [*performance_backend_servers*]
#   An array of Performance Platform backend app servers
#
# [*whitehall_backend_servers*]
#   An array of whitehall backend app servers
#
# [*maintenance_mode*]
#   Whether the backend should be taken offline in nginx
#
class govuk::node::s_backend_lb (
  $perfplat_public_app_domain = 'performance.service.gov.uk',
  $backend_servers,
  $performance_backend_servers = [],
  $whitehall_backend_servers,
  $maintenance_mode = false,
){
  include govuk::node::s_base
  include loadbalancer

  $errbit_servers = ['exception-handler-1']
  $app_domain = hiera('app_domain')

  Loadbalancer::Balance {
    maintenance_mode => $maintenance_mode,
  }

  loadbalancer::balance {
    [
      'hmrc-manuals-api',
    ]:
      error_on_http => true,
      servers       => $backend_servers;
    [
      'specialist-publisher',
    ]:
      modified_paths => {
        '/sp-rebuild/assets'   => {
          'app' => 'specialist-publisher-rebuild',
        },
        '/rebuild-healthcheck' => {
          'app' => 'specialist-publisher-rebuild',
        },
        '/preview'             => {
          'app' => 'specialist-publisher-rebuild',
        },
      },
      servers => $backend_servers;
    [
      'business-support-api',
      'collections-publisher',
      'contacts-admin',
      'content-tagger',
      'imminence',
      'local-links-manager',
      'maslow',
      'panopticon',
      'policy-publisher',
      'private-frontend',
      'publisher',
      'release',
      'search-admin',
      'service-manual-publisher',
      'share-sale-publisher',
      'signon',
      'specialist-publisher-rebuild-standalone',
      'short-url-manager',
      'support',
      'tariff-admin',
      'travel-advice-publisher',
      'transition',
    ]:
      servers => $backend_servers;
    [
      'asset-manager',
      'canary-backend',
      'contentapi',
      'email-alert-api',
      'event-store',
      'govuk-delivery',
      'need-api',
      'publishing-api',
      'specialist-publisher-rebuild',
      'support-api',
      'tariff-api',
    ]:
      https_redirect => false, # FIXME: Remove for #51136581
      internal_only  => true,
      servers        => $backend_servers;
    'whitehall-admin':
      deny_crawlers => true,
      servers       => $whitehall_backend_servers;
  }

  loadbalancer::balance { 'errbit':
    servers => $errbit_servers,
  }

  loadbalancer::balance { 'kibana':
    read_timeout => 5,
    servers      => $backend_servers,
  }

  if !empty($performance_backend_servers) {
    loadbalancer::balance { 'performanceplatform-admin':
      servers        => $performance_backend_servers,
      internal_only  => false,
      https_redirect => true,
    }
  }

  nginx::config::vhost::redirect { "backdrop-admin.${app_domain}" :
    to => "https://admin.${perfplat_public_app_domain}/",
  }
}
