# == Class: govuk::apps::kibana
#
# A redirect to point people to Kibana provided by Logit.
# The URL sets the account and environment in a session.
#
class govuk::apps::kibana(
  $logit_account = undef,
  $logit_environment = undef,
) {

  $app_name = 'kibana'
  $app_domain = hiera('app_domain')

  nginx::config::vhost::redirect { "${app_name}.${app_domain}":
    to => "https://logit.io/a/${logit_account}/s/${logit_environment}/kibana/access",
  }

  if $::aws_migration {
    concat::fragment { 'kibana_lb_healthcheck':
      target  => '/etc/nginx/lb_healthchecks.conf',
      content => "location /_healthcheck_kibana {\n  return 200;\n}\n",
    }
  }
}
