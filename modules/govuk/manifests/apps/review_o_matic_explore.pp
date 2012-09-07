class govuk::apps::review_o_matic_explore( $port = 3023 ) {
  if $::govuk_platform == 'development' {
    $upstream_domain = 'dev.gov.uk'
  } else {
    $upstream_domain = "${::govuk_platform}.alphagov.co.uk"
  }

  govuk::app { 'review-o-matic-explore':
    app_type        => 'procfile',
    port            => $port,
    environ_content => template('govuk/etc/envmgr/review-o-matic-explore.conf.erb'),
    vhost           => 'explore-reviewomatic',
    vhost_ssl_only  => false,
    require         => Class['nodejs'];
  }

  nginx::config::vhost::proxy { "explore-dg.${upstream_domain}":
    to           => ["localhost:${port}"],
    extra_config => "
            proxy_set_header X-Explore-Title Directgov;
            proxy_set_header X-Explore-Upstream www.direct.gov.uk;
            proxy_set_header X-Explore-Redirector redirector.${upstream_domain};
    ",
  }

  nginx::config::vhost::proxy { "explore-bl.${upstream_domain}":
    to           => ["localhost:${port}"],
    extra_config => "
            proxy_set_header X-Explore-Title 'Business Link';
            proxy_set_header X-Explore-Upstream www.businesslink.gov.uk;
            proxy_set_header X-Explore-Redirector redirector.${upstream_domain};
    ",
  }
}
