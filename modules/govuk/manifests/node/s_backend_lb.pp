# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_backend_lb (
  $perfplat_public_app_domain = 'performance.service.gov.uk',
  $backend_servers,
  $mapit_servers,
  $whitehall_backend_servers
){
  include govuk::node::s_base
  include loadbalancer

  $errbit_servers = ['exception-handler-1']
  $app_domain = hiera('app_domain')

  Loadbalancer::Balance {
    servers => $backend_servers,
  }

  loadbalancer::balance {
    [
      'business-support-api',
      'collections-api',
      'collections-publisher',
      'contacts-admin',
      'content-planner',
      'fact-cave',
      'hmrc-manuals-api',
      'imminence',
      'maslow',
      'panopticon',
      'private-frontend',
      'publisher',
      'release',
      'search-admin',
      'signon',
      'specialist-publisher',
      'short-url-manager',
      'support',
      'tariff-admin',
      'travel-advice-publisher',
      'transition',
      'transition-postgres',
      'url-arbiter',
    ]:
      https_only => false; # FIXME: Remove for #51136581
    [
      'api-external-link-tracker',
      'asset-manager',
      'canary-backend',
      'contentapi',
      'email-alert-api',
      'external-link-tracker',
      'finder-api',
      'need-api',
      'govuk-delivery',
      'search',
      'support-api',
      'tariff-api',
    ]:
      https_only    => false, # FIXME: Remove for #51136581
      internal_only => true;
    'whitehall-admin':
      https_only => false, # FIXME: Remove for #51136581
      servers    => $whitehall_backend_servers;
  }

  loadbalancer::balance { 'errbit':
    servers    => $errbit_servers,
    https_only => false, # FIXME: Remove for #51136581
  }

  loadbalancer::balance { 'kibana':
    read_timeout => 5,
    https_only   => false, # FIXME: Remove for #51136581
  }

  loadbalancer::balance { 'mapit':
    servers       => $mapit_servers,
    internal_only => true,
    https_only    => false, # FIXME: Remove for #51136581
  }

  nginx::config::vhost::redirect { "backdrop-admin.${app_domain}" :
    to => "https://admin.${perfplat_public_app_domain}/",
  }
}
