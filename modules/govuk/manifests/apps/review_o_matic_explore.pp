class govuk::apps::review_o_matic_explore( $port = 3023 ) {

  $upstream_domain = extlookup('app_domain')

  govuk::app { 'review-o-matic-explore':
    app_type        => 'procfile',
    port            => $port,
    environ_content => template('govuk/etc/envmgr/review-o-matic-explore.conf.erb'),
    vhost           => 'explore-reviewomatic',
    vhost_ssl_only  => false,
    require         => Class['nodejs'],
  }

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
