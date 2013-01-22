# The GOV.UK canary is a simple uncacheable item on www.gov.uk which is used
# to assert that the origin datacentre is up. It is fetched by Pingdom.

class govuk::apps::canary_frontend {

  $app_domain = extlookup('app_domain')

  # This doesn't actually use a port, but declare a "virtual" port for use in
  # calculations of healthcheck ports
  $port = 3200
  $health_check_port = $port + 6500
  $ssl_health_check_port = $port + 6400

  @ufw::allow {
    'allow-loadbalancer-health-check-canary_frontend-http-from-all':
      port => $health_check_port;
    'allow-loadbalancer-health-check-canary_frontend-https-from-all':
      port => $ssl_health_check_port;
  }

  nginx::config::site { "canary-frontend.${app_domain}":
    content => "
      server {
        listen 80;
        listen ${health_check_port};
        listen 443 ssl;
        listen ${ssl_health_check_port} ssl;
        server_name canary-frontend.${app_domain};
        location / {
          proxy_pass http://canary-backend.${app_domain};
        }
      }
    ",
  }

}
