class govuk::apps::publicapi {
  $platform = $::govuk_platform

  $domain = $platform ? {
    'development' => 'dev.gov.uk',
    default       => "${platform}.alphagov.co.uk",
  }

  nginx::config::vhost::proxy { "public-api.${domain}":
    to                => ["contentapi.${domain}"],
    protected         => false,
    ssl_only          => false,
    platform          => $platform
  }
}
