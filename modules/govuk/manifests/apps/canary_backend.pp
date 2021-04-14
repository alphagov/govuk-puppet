# The GOV.UK canary is a simple uncacheable item on www.gov.uk which is used
# to assert that the origin datacentre is up. It is fetched by Pingdom.
#
# At the moment, it doesn't return any useful information other than its
# status code. In the future, it might be worth swapping out this simple nginx
# config with an actual application that returns some diagnostics data.
class govuk::apps::canary_backend {

  $app_domain = hiera('app_domain')

  nginx::config::site { 'canary-backend':
    content => "
      server {
        listen 80;
        listen 443 ssl;
        server_name canary-backend canary-backend.*;
        location / {
          default_type application/json;
          add_header cache-control \"max-age=0,no-store,no-cache\";
          return 200 '{\"message\": \"Tweet tweet\"}\\n';
        }
      }
    ",
  }

  concat::fragment { 'canary-backend_lb_healthcheck':
    target  => '/etc/nginx/lb_healthchecks.conf',
    content => "location /_healthcheck_canary-backend {\n  proxy_pass http://localhost/healthcheck;\n  proxy_set_header Host canary-backend;\n}\n",
  }

}
