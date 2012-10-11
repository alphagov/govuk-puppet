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
      location /api {
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

  if $platform == 'preview' {
    # FIXME only needed for a short time (less than a day) while migrating.
    # -- ppotter, 2012-10-11
    $legacy_app_name = 'public-api'
    $legacy_full_domain = "${legacy_app_name}.${domain}"

    nginx::config::vhost::proxy { $legacy_full_domain:
      to                => [$privateapi],
      protected         => false,
      ssl_only          => false,
      platform          => $platform,
      extra_config      => "
        location /api {
          proxy_set_header Host ${privateapi};
          proxy_set_header API-PREFIX api;
          proxy_set_header Authorization  \"\";
          proxy_pass http://${legacy_full_domain}-proxy/;
        }

        location /api/specialist {
          proxy_set_header Host ${whitehallapi};
          proxy_pass http://${whitehallapi};
        }
      "
    }
  }
}
