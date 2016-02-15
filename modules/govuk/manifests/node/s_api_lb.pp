# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_api_lb (
  $api_servers,
  $content_store_servers,
  $draft_content_store_servers,
  $email_campaign_api_servers,
  $mapit_servers,
  $search_servers,
) {
  include govuk::node::s_base
  include loadbalancer

  validate_array($api_servers)
  validate_array($content_store_servers)
  validate_array($draft_content_store_servers)
  validate_array($email_campaign_api_servers)
  validate_array($search_servers)

  loadbalancer::balance {
    [
      'backdrop-read',
      'metadata-api',
      'stagecraft',
    ]:
      servers       => $api_servers,
      internal_only => true;
  }

  loadbalancer::balance {
    [
      'backdrop-write',
    ]:
      servers       => $api_servers,
      read_timeout  => 60,
      internal_only => true;
  }

  loadbalancer::balance {
    [
      'content-store',
    ]:
      servers       => $content_store_servers,
      internal_only => true;
  }

  loadbalancer::balance {
    [
      'draft-content-store',
    ]:
      servers       => $draft_content_store_servers,
      internal_only => true,
      https_only    => true,
      https_port    => 8443,
  }
  @ufw::allow { 'allow-https-8443-from-any':
    port => 8443,
  }

  loadbalancer::balance { 'email-campaign-api':
    servers       => $email_campaign_api_servers,
    internal_only => true,
  }

  loadbalancer::balance { 'mapit':
    servers       => $mapit_servers,
    internal_only => true,
    https_only    => false, # FIXME: Remove for #51136581
  }

  loadbalancer::balance {
    [
      'rummager',

      # support search as an alias for ease of migration from old
      # cluster running in backend VDC.
      'search',
    ]:
      servers       => $search_servers,
      https_only    => false, # Necessary for the router to fetch sitemaps.
      internal_only => true;
  }
}
