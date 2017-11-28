class govuk::apps::email_status_updates {
  $port = '3088'
  $app_domain = hiera('app_domain')

  nginx::config::site { "email-status-updates.${app_domain}":
    content => "
      upstream email-status-updates.${app_domain}-proxy {
        server localhost:${port};
      }

      server {
        server_name email-status-updates.${app_domain};

        listen 80;
        listen 443 ssl;

        ssl_certificate /etc/nginx/ssl/email-alert-api.${app_domain}.crt;
        ssl_certificate_key /etc/nginx/ssl/email-alert-api.${app_domain}.key;
        include /etc/nginx/ssl.conf;

        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods POST;

        location / {
          proxy_pass http://email-status-updates.${app_domain}-proxy/status_updates;
        }
      }
    ",
  }
}
