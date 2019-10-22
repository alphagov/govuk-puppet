# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_api_lb (
  $api_servers,
) {
  include govuk::node::s_base
  include loadbalancer

  validate_array($api_servers)

  loadbalancer::balance {
    [
      'backdrop-read',
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

  @ufw::allow { 'allow-https-8443-from-any':
    port => 8443,
  }
}
