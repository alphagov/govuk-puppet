# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_frontend_lb (
  $calculators_frontend_servers,
  $draft_email_campaign_frontend_servers,
  $draft_frontend_servers,
  $email_campaign_frontend_servers,
  $frontend_servers,
  $hide_frontend_apps = true,
  $performance_frontend_apps = [],
  $performance_frontend_servers = [],
){
  $whitehall_frontend_servers = split(generate('/usr/local/bin/govuk_node_list', '-c', 'whitehall_frontend'), '\n')

  include govuk::node::s_base
  include loadbalancer

  Loadbalancer::Balance {
    https_redirect => false, # Varnish/Router can't speak HTTPS.
    internal_only  => $hide_frontend_apps,
  }

  loadbalancer::balance {
    [
      'draft-collections',
      'draft-contacts-frontend',
      'draft-email-alert-frontend',
      'draft-government-frontend',
      'draft-manuals-frontend',
      'draft-multipage-frontend',
      'draft-service-manual-frontend',
      'draft-specialist-frontend',
      'draft-static',
    ]:
      servers       => $draft_frontend_servers;
    [
      'canary-frontend',
      'collections',
      'contacts-frontend',
      'contacts-frontend-old',
      'designprinciples',
      'email-alert-frontend',
      'feedback',
      'frontend',
      'government-frontend',
      'info-frontend',
      'manuals-frontend',
      'multipage-frontend',
      'service-manual',
      'service-manual-frontend',
      'specialist-frontend',
      'static',
    ]:
      servers       => $frontend_servers;
    [
      'businesssupportfinder',
      'calculators',
      'calendars',
      'finder-frontend',
      'licencefinder',
      'smartanswers',
      'tariff',
    ]:
      servers       => $calculators_frontend_servers;
    'whitehall-frontend':
      servers       => $whitehall_frontend_servers;
    $performance_frontend_apps:
      servers       => $performance_frontend_servers;
    'email-campaign-frontend':
      servers       => $email_campaign_frontend_servers;
    'draft-email-campaign-frontend':
      servers       => $draft_email_campaign_frontend_servers,
  }
}
