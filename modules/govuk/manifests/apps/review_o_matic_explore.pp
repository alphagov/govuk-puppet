class govuk::apps::review_o_matic_explore( $port = 3023 ) {

  $upstream_domain = extlookup('app_domain')

  $http_username = extlookup('http_username')
  $http_password = extlookup('http_password')

  govuk::app { 'review-o-matic-explore':
    app_type        => 'procfile',
    port            => $port,
    vhost           => 'explore-reviewomatic',
    vhost_ssl_only  => false,
    require         => Class['nodejs'],
  }

  # Set default app for govuk::app::envvar in this scope
  Govuk::App::Envvar { app => 'review-o-matic-explore' }

  # Backwards compatibility
  govuk::app::envvar { 'UPSTREAM_AUTH':
    value => "${http_username}:${http_password}",
  }
  govuk::app::envvar { 'UPSTREAM_HOST':
    value => "reviewomatic.${upstream_domain}",
  }

  # New reviewomatic-explore
  govuk::app::envvar { 'REVIEWOMATIC_AUTH':
    value => "${http_username}:${http_password}",
  }
  govuk::app::envvar { 'REVIEWOMATIC_HOST':
    value => "reviewomatic.${upstream_domain}",
  }
  govuk::app::envvar { 'REVIEWOMATIC_PROTOCOL':
    value => 'https',
  }

  # ... yes, we need a better syntax for creating application-specific
  # environment variables.

  nginx::config::vhost::proxy { "explore-dg.${upstream_domain}":
    to           => ["localhost:${port}"],
    extra_config => "
            proxy_set_header X-Explore-Title Directgov;
            proxy_set_header X-Explore-Upstream www.direct.gov.uk;
            proxy_set_header X-Explore-Redirector www-direct-gov-uk.redirector.${upstream_domain};
    ",
  }

  nginx::config::vhost::proxy { "explore-bl.${upstream_domain}":
    to           => ["localhost:${port}"],
    extra_config => "
            proxy_set_header X-Explore-Title 'Business Link';
            proxy_set_header X-Explore-Upstream www.businesslink.gov.uk;
            proxy_set_header X-Explore-Redirector www-businesslink-gov-uk.redirector.${upstream_domain};
    ",
  }
}
