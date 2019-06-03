# The GOV.UK canary is a simple uncacheable item on www.gov.uk which is used
# to assert that the origin datacentre is up. It is fetched by Pingdom.
class govuk::apps::canary_frontend {

  $app_domain = hiera('app_domain')

  if $::aws_migration {
    $app_domain_internal = hiera('app_domain_internal')

    nginx::config::site { 'canary-frontend':
      content => "
        server {
          listen 80;
          server_name canary-frontend canary-frontend.*;
          location / {
            proxy_pass https://canary-backend.${app_domain_internal};
          }
        }
      ",
    }

    if $::aws_environment != 'production' {
      concat::fragment { 'canary-frontend_lb_healthcheck':
        target  => '/etc/nginx/lb_healthchecks.conf',
        content => "location /_healthcheck_canary-frontend {\n  return 200;\n}\n",
      }
    }
  } else {
    nginx::config::site { "canary-frontend.${app_domain}":
      content => "
        server {
          listen 80;
          listen 443 ssl;
          server_name canary-frontend.${app_domain};
          location / {
            proxy_pass https://canary-backend.${app_domain};
          }
        }
      ",
    }
  }
}
