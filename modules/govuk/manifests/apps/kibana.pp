# == Class: govuk::apps::kibana
#
# A redirect to point people using the legacy Kibana domain to
# docs for how to check Kibana on our ELK SaaS provider.
#
class govuk::apps::kibana {
  $app_name = 'kibana'

  $app_domain = hiera('app_domain')

  nginx::config::vhost::redirect { "${app_name}.${app_domain}":
    to => 'https://docs.publishing.service.gov.uk/manual/logit.html',
  }
}
