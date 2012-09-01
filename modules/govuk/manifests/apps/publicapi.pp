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

  nginx::config::vhost::proxy { "public-api.${domain}":
    to                => [$privateapi],
    protected         => false,
    ssl_only          => false,
    platform          => $platform
  }
}
