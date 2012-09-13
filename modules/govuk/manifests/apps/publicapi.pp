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

  $full_domain = "public-api.${domain}"

  nginx::config::vhost::proxy { $full_domain:
    to                => [$privateapi],
    protected         => false,
    ssl_only          => false,
    platform          => $platform,
    extra_config      => "
      location /api {
        proxy_set_header Host ${privateapi};
        proxy_set_header API_PREFIX api;
        proxy_pass http://${full_domain}-proxy/;
      }

      location /api/specialist {
        proxy_pass http://${whitehallapi};
      }
    "
  }
}
