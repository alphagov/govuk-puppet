class govuk::apps::publicapi {
  $platform = $::govuk_platform

  $domain = $platform ? {
    'development' => 'dev.gov.uk',
    default       => "${platform}.alphagov.co.uk",
  }

  $privateapi = $platform ? {
    'development' => 'localhost:3022',
    default       => "contentapi.${domain}"
  }

  $whitehallapi = $platform ? {
    'development' => 'localhost:3020',
    default       => "whitehall-frontend.${domain}"
  }

  $app_name = 'publicapi'
  $full_domain = "${app_name}.${domain}"

  nginx::config::vhost::proxy { $full_domain:
    to                => [$privateapi],
    protected         => false,
    ssl_only          => false,
    platform          => $platform,
    extra_config      => "
      expires 30m;

      # Specify this location explicitly to avoid Nginx automatically
      # issuing a 301 redirect if a corresponding location with a
      # trailing slash exists and has a proxy_pass directive.
      location = /api {
        proxy_set_header Host ${privateapi};
        proxy_set_header API-PREFIX api;
        proxy_set_header Authorization  \"\";
        proxy_pass http://${full_domain}-proxy/;
      }

      location /api/ {
        proxy_set_header Host ${privateapi};
        proxy_set_header API-PREFIX api;
        proxy_set_header Authorization  \"\";
        proxy_pass http://${full_domain}-proxy/;
      }

      location /api/specialist {
        proxy_set_header Host ${whitehallapi};
        proxy_pass http://${whitehallapi};
      }
    "
  }
}
